class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  EU_AND_INDIA_MARKETPLACES = ["A1PA6795UKMFR9", "A1RKKUPIHCS9HS", "A13V1IB3VIYZZH", "APJ6JRA9NG5V4",
                          "A1F83G8C2ARO7P", "A21TJRUUN4KGV"]
  AUSTRALIA_MARKETPLACE = ["A39IBJ37TRP1C6"]
  NA_MARKETPLACES = ["A1AM78C64UM0Y8", "A2EUQ1WTGCTBG2", "ATVPDKIKX0DER"]

  def current_store
    @current_store ||= Store.find(session[:fba_shipping_id])
  end
  
  def get_store_via_params(my_params)
    bc_hash = my_params['store_id']
    Store.find_by(bc_hash: bc_hash) 
  end

  def store_hash_via_payload
    signed_payload = params[:signed_payload]
    message_parts = signed_payload.split('.')
    encoded_json_payload = message_parts[0]
    payload = Base64.decode64(encoded_json_payload)
    JSON.parse(payload)
  end

  def create_request_headers(store)
    auth_token = store.token
    {"X-Auth-Client"  => "#{ENV["BC_CLIENT_ID"]}",
    "X-Auth-Token" => auth_token,
    "Accept" => "application/json",
    "Content-Type" => "application/json"}
  end
  
  def create_bc_connection  
    @bc_connection ||= Bigcommerce::Connection.build(
      Bigcommerce::Config.new(
        store_hash: current_store.bc_hash,
        client_id: ENV["BC_CLIENT_ID"],
        access_token: current_store.token,
        v2: true
      )
    )
  end

  def create_bc_connection_with_store(store)  
    @bc_connection ||= Bigcommerce::Connection.build(
      Bigcommerce::Config.new(
        store_hash: store.bc_hash,
        client_id: ENV["BC_CLIENT_ID"],
        access_token: store.token,
        v2: true
      )
    )
  end
    
  
  def which_amazon_keys_to_use?(marketplace)
    case
      when NA_MARKETPLACES.include?(marketplace)
        return {access_key: ENV["us_aws_access_key_id"], secret_access_key: ENV["us_aws_secret_access_key"]}
      when EU_AND_INDIA_MARKETPLACES.include?(marketplace)
        return {access_key: ENV["eu_and_india_aws_access_key_id"], secret_access_key: ENV["eu_and_india_aws_secret_access_key"]}
      else
        return {access_key: ENV["australia_aws_access_key_id"], secret_access_key: ENV["australia_aws_secret_access_key"]}
    end
  end
  
  
end
