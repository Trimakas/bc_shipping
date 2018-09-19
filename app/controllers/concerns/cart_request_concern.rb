module CartRequestConcern
  extend ActiveSupport::Concern
  include ApplicationConcern

  def get_cart(my_params)
    store = get_store_via_params(my_params)
    domain = store.bc_hash
    cart_id = my_params["request_context"]["reference_values"][0]["value"]
    HTTParty.get(
      "https://api.bigcommerce.com/stores/#{domain}/v3/carts/#{cart_id}", 
      :headers => create_request_headers(store)
      )
  end
  
  def get_cart_amount(my_params)
    cart = get_cart(my_params)
    cart["data"]["cart_amount"]
  end

end
