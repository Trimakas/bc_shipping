class WelcomeController < ApplicationController
  include AmazonRateConcern
  include BCRateResponseConcern
  include CartRequestConcern
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  attr_reader :address, :items, :rate_preview

  def index
  end
  
  def amazon_creds #this is where the request for quotes is coming in for now..
    prep_amazon_rate_request
    rate_preview = request_amazon_rates
    if rate_preview != "no_rates"
      pre_adjusted_parsed_amazon_rates = parse_rates_from_amazon(rate_preview)
      final_amazon_rates = adjust_amazon_rates(pre_adjusted_parsed_amazon_rates, get_cart_amount(my_params))
      prep_bc_rate_response(final_amazon_rates)
      render json: bc_rate_response
    else
      render json: bc_rate_response_when_no_amazon_response
    end
  end
  
  def where_to_send_user
    where_to_go = 'welcome'
    if current_store.setup
      where_to_go = 'speeds'
    else
      where_to_go = 'welcome'
    end
    render json: where_to_go
  end

  private
  
  def prep_amazon_rate_request
    get_always_present_shipping_info(my_params)
    get_name_and_address(my_params)
    get_skus_and_quantity(my_params)
    @address = setup_address_struct
    @items = setup_items_struct
  end
  
  def request_amazon_rates
    client = create_fulfillment_client
    begin
      client.get_fulfillment_preview(address, items).parse
    rescue StandardError => e
      return "no_rates"
      Rails.logger.info "\nWhat went wrong with the request for rates from Amazon? #{e.response.body}\n"
    end
  end
  
  def create_fulfillment_client
    store = get_store_via_params(my_params)
    marketplace = store.amazon.marketplace
    seller_id = store.amazon.seller_id
    auth_token = store.amazon.auth_token
    create_amazon_client(marketplace, seller_id, auth_token)
  end
  
  def my_params
    params.require(:base_options)
  end

end