module OrderConcern
  extend ActiveSupport::Concern
  include ApplicationConcern
  include StateNameConcern
  attr_reader :order_id, :store, :products, :address, :client, :address, :marketplace, :order_params, :auth_token, :seller_id
  
  Address = Struct.new(:name, :line_1, :line_2, :line_3, :city, :state_or_province_code,
                      :country_code, :postal_code)
  
  Item = Struct.new(:seller_sku, :seller_fulfillment_order_item_id, :quantity)
  
  ORDER_STATUS = [{id: 0, status: "incomplete"}, {id: 1, status: "pending"}, {id: 2, status: "shipped"},
                  {id: 3, status: "partially shipped"}, {id: 4, status: "refunded"}, {id: 5, status: "cancelled"}, 
                  {id: 6, status: "declined"}, {id: 7, status: "awaiting payment"}, {id: 8, status: "awaiting pickup"},
                  {id: 9, status: "awaiting shipment"}, {id: 10, status: "completed"}, {id: 11, status: "awaiting fulfillment"},
                  {id: 12, status: "manual verification required"},{id: 13, status: "disputed"}, 
                  {id: 14, status: "partially refunded"}]
  
  def what_to_do_with_order(order_params, store, products, address)
    @order_params = order_params
    @store = store
    @products = products
    @address = address
    setup_amazon_client
    new_order_or_update
  end
  
  def find_bc_order_in_db
    Order.find_by(store_id: store.id, bc_order_id: order_params["data"]["id"])
  end
  
  def new_order_or_update
    order = find_bc_order_in_db
    @order_id = order_params["data"]["id"]
    if order.nil?
      Order.create(bc_order_id: @order_id,
                  amazon_order_id: @order_id,
                  store_id: store.id,
                  order_status: return_bc_status,
                  fulfillable: true)
      send_bc_order_to_amazon
    else
      status = return_bc_status
      order.update(order_status: status)
      if does_order_exist_at_amazon?(order)
        cancel_on_amazon_if_needed(status, order)
      end
    end
  end
  
  def does_order_exist_at_amazon?(order)
    does_order_exist = false
    begin
      client.get_fulfillment_order(order.amazon_order_id)
    rescue StandardError => e 
      Rails.logger.info "\n nope, doesn't look like the order exists at Amazon, this is the order #{order} and the message from amazon #{e}\n" 
    else
      does_order_exist = true
    end
    return does_order_exist
  end
  
  def cancel_on_amazon_if_needed(status, order)
    if status == "cancelled"
      begin
        amazon_order = client.get_fulfillment_order(order.amazon_order_id).parse
      rescue StandardError => e
        Rails.logger.info "Order id #{order.amazon_order_id} from user #{seller_id} failed because of #{e}"
      else
        cancel_on_amazon_if_not_canceled_before(amazon_order, order_id)
      end
    end
  end
  
  def cancel_on_amazon_if_not_canceled_before(amazon_order, order_id)
    amazon_order_status = amazon_order["FulfillmentOrder"]["FulfillmentOrderStatus"]
    unless amazon_order_status == "CANCELLED"
      client.cancel_fulfillment_order(order_id)
    end
  end
  
  def return_bc_status
    id = order_params["data"]["status"]["new_status_id"]
    bc_order_status = ""
    ORDER_STATUS.each do |status|
      if status.has_value?(id)
        bc_order_status = status[:status]
      end
    end
    return bc_order_status
  end
  
  def send_bc_order_to_amazon #NOT SURE IF THIS IS RIGHT! I'm only sending orders with a status of 11 to amazon.
    order_status_id = order_params[:data][:status][:new_status_id]
    if order_status_id == 11
      @address = address[0]
      create_amazon_order
    end
  end
  
  def setup_amazon_client
    @marketplace ||= store.amazon.marketplace
    @seller_id ||= store.amazon.seller_id
    @auth_token ||= store.amazon.auth_token
    @client ||= create_amazon_client(@marketplace, @seller_id, @auth_token)
  end
  
  def create_amazon_order
    db_order = Order.find_by(store_id: store.id, bc_order_id: get_bc_order_id)
    begin
      client.create_fulfillment_order(
        get_bc_order_id, 
        get_bc_order_id, 
        Time.now.getutc, 
        "Thank You",
        get_shipping_speed(address), 
        create_amazon_shipping_address,
        create_amazon_skus, opts = {marketplace_id: store.amazon.marketplace})
    rescue StandardError => e
      db_order.update(order_status: "send to amazon failed because of #{e}")
      Rails.logger.info "\n This order got messed up! bc_order_id is : #{get_bc_order_id} and this happened: #{e}"
    else
      db_order.update(order_status: "sent to amazon", sent_to_amazon: true)
    end
  end
  
  def get_bc_order_id
    @order_id ||= address[:order_id]
  end
  
  def get_shipping_speed(address)
    shipping_method = address.shipping_method
    shipping_method.scan(/\(([^\)]+)\)/).first.first
  end
  
  def create_amazon_shipping_address
    first_name = address[:first_name]
    last_name = address[:last_name]
    name = [first_name, last_name].join(' ')
    line_1 = address[:street_1]
    line_2 = address[:street_2]
    city = address[:city]
    state = convert_state_name_to_code(address[:state])
    country_code = address[:country_iso2]
    zip = address[:zip]
    Address.new(name, line_1, line_2, "", city, state, country_code, zip)
  end
  
  def create_amazon_skus
    skus = []
    products.each do |item|
      item_id = 3.times.map { [*'0'..'9', *'a'..'z'].sample }.join
      skus << Item.new(item.sku, item_id, item.quantity)
    end
    return skus
  end
  
end