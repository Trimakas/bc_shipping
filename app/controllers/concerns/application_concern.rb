module ApplicationConcern
extend ActiveSupport::Concern

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
  
  def create_request_headers(store)
    auth_token = store.token
    {"X-Auth-Client"  => "#{ENV["BC_CLIENT_ID"]}",
    "X-Auth-Token" => auth_token,
    "Accept" => "application/json",
    "Content-Type" => "application/json"}
  end
  
  def create_amazon_client(marketplace, seller_id, auth_token)
    keys = which_amazon_keys_to_use?(marketplace)
    MWS::FulfillmentOutboundShipment::Client.new(
                                              marketplace:           "#{marketplace}",
                                              merchant_id:           "#{seller_id}",
                                              aws_access_key_id:     "#{keys[:access_key]}",
                                              aws_secret_access_key: "#{keys[:secret_access_key]}",
                                              auth_token:            "#{auth_token}")
  end

end