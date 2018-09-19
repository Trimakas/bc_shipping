module AmazonRateConcern
  extend ActiveSupport::Concern
  include ApplicationConcern
  include AmazonRateAdjustConcern
  attr_reader :name, :address1, :address2, :city, :state, :country_code, :zip, :sku_and_quantity
  
  Address = Struct.new(:name, :line_1, :line_2, :line_3, :city, :state_or_province_code, :country_code, :postal_code)
  Item = Struct.new(:seller_sku, :seller_fulfillment_order_item_id, :quantity)


  def get_always_present_shipping_info(my_params) #everything but name and address, sometimes name and address isn't present when they preview rates in the cart
    @city = my_params[:destination][:city]
    @state = my_params[:destination][:state_iso2]
    @country_code = my_params[:destination][:country_iso2]
    @zip = my_params[:destination][:zip]
  end
  
  def get_name_and_address(my_params)
    if do_we_need_a_fake_address?(my_params)
      @name = "Joe Schmoe"
      @address1 = "123 Main Street"
    else
      @name =  my_params[:destination][:name]
      @address1 = my_params[:destination][:street_1]
      @address2 = my_params[:destination][:street_2]
    end
  end
  
  def do_we_need_a_fake_address?(my_params)
    my_params[:destination][:name].empty?
  end
  
  def setup_address_struct
    Address.new(name, address1, address2, "", city, state, country_code, zip)
  end
  
  def setup_items_struct
    items = []
    sku_and_quantity.map do |product|
      seller_sku = product[:sku]
      seller_fulfillment_order_item_id = "bytestand_#{(0...8).map { (65 + rand(26)).chr }.join.downcase}"
      quantity = product[:quantity]
      items <<  Item.new(seller_sku, seller_fulfillment_order_item_id, quantity)
    end
  end
  
  def get_skus_and_quantity(my_params)
    @sku_and_quantity = []
    my_params[:items].each do |product|
      @sku_and_quantity << {sku: product["sku"], quantity: product["quantity"]}
    end
  end
  
  def parse_rates_from_amazon(amazon_fee_response)
    amazon_rates = []
    amazon_fee_response["FulfillmentPreviews"]["member"].each do |speed|
      if speed["IsFulfillable"] == "true"
        arrival_date = speed["FulfillmentPreviewShipments"]["member"]["EarliestArrivalDate"]
        amazon_rates  << {speed: speed["ShippingSpeedCategory"], 
                          amount: speed["EstimatedFees"]["member"]["Amount"]["Value"],
                          currency: speed["EstimatedFees"]["member"]["Amount"]["CurrencyCode"],
                          transit_duration: determine_transit_duration(arrival_date)}
      end
    end
    return amazon_rates
  end

  def determine_transit_duration(arrival_date)
    today = DateTime.now
    delivery = DateTime.parse(arrival_date)
    (delivery - today).round
  end

end