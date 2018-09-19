module SqsPollHelp
extend self

  def create_sqs_client
    Aws::SQS::Client.new(region: 'us-east-1',
                              access_key_id:     ENV['sqs_access_key'],
                              secret_access_key: ENV['sqs_secret_access_key'])
  end
  
  def what_to_do_with_message(xml_message_from_amazon)
    if is_order_ours?(xml_message_from_amazon)
      order_status = xml_message_from_amazon.css('FulfillmentOrderStatus').text.downcase
      case order_status
        when "received"
          open_bc_order
          update_order_status_in_db("amazon received")
        when "complete"
          provide_tracking_number_to_bc(xml_message_from_amazon)
          update_order_with_tracking_in_db
          update_order_status_in_db("amazon shipped")
        when "cancelled"
          cancel_bc_order
          update_order_status_in_db("cancelled")
      end
    end
  end
  
  def is_order_ours?(xml_message_from_amazon)
    @order_id = xml_message_from_amazon.css('SellerFulfillmentOrderId').text.to_i
    amazon_seller_id = xml_message_from_amazon.css('SellerId').text.upcase
    is_order_ours = false
    amazon_account = Amazon.find_by(seller_id: amazon_seller_id)
    unless amazon_account.nil?
      @store = amazon_account.store
      is_order_ours = !@store.orders.find_by(bc_order_id: @order_id).nil?
    end
    return is_order_ours
  end
  
  def open_bc_order # really its marked to "awaiting shipment"
    Bigcommerce::Order.update(@order_id, status_id:  9, connection: create_bc_connection_with_store(@store))
  end
  
  def provide_tracking_number_to_bc(xml_message_from_amazon)
    get_bc_order_details
    get_amazon_shipment_details(xml_message_from_amazon)
    Bigcommerce::Shipment.create(
      @order_id,
      tracking_number: @tracking_number,
      shipping_provider: @shipping_provider,
      comments: 'Thank you from ByteStand',
      order_address_id: @order_address_id,
      items: @items, connection: create_bc_connection_with_store(@store))
  end
  
  def update_order_with_tracking_in_db
   order = Order.find_by(bc_order_id: @order_id, store_id: @store.id)
   order.update(tracking_number: @tracking_number, carrier: @shipping_provider)
  end
  
  def cancel_bc_order
    Bigcommerce::Order.update(@order_id, status_id:  5, connection: create_bc_connection_with_store(@store))
  end
  
  def get_amazon_shipment_details(xml_message_from_amazon)
    @tracking_number = xml_message_from_amazon.css('TrackingNumber').text
    @shipping_provider = xml_message_from_amazon.css('CarrierCode').text.downcase
  end
  
  def update_order_status_in_db(status)
    order = @store.orders.find_by(bc_order_id: @order_id)
    order.update(order_status: status)
  end
  
  def get_bc_order_details
    bc_order = Bigcommerce::OrderProduct.all(@order_id.to_i, connection: create_bc_connection_with_store(@store))
    @items = []
    bc_order.each do |line_item|
      @order_address_id = line_item.order_address_id
      @items << {order_product_id: line_item.id, quantity: line_item.quantity}
    end
  end
  
  def create_bc_connection_with_store(store)  
    @bc_connection ||= Bigcommerce::Connection.build(
      Bigcommerce::Config.new(
        store_hash: store.bc_hash,
        client_id: ENV["BC_CLIENT_ID"],
        access_token: store.token,
        v2: true))
  end
  
end