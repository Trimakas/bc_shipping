class OmniauthController < ApplicationController
  include SqsConcern
  include WebhookConcern
  include ShippingZoneConcern
  attr_reader :send_to_bc, :bc_response_body, :store_hash, :owner_id, :currency_code, :currency_symbol, :store, :loaded_store
  
# /auth/:name/callback
# This URL handles installation process callback. When someone installs your application first time. 
# From here you can get store details and store it into your database.

# /load BigCommerce loads your whole Rails application into one iframe. 
# So whenever any store owner load your application, this method will be called first.

# /uninstall
# It is important to implement this method to handle data removal when a store owner removes your application.
  
  def callback
    get_access_token
    get_bc_response_body
    get_store_info
    @store = create_store
    set_bc_session_during_install(@store)
    get_shipping_zones(@store)
    redirect_to root_path
  end
  
  #load runs when opening the app
  def load
    set_bc_session_during_load
    get_store_currency_info(loaded_store.bc_hash, loaded_store.token)
    redirect_to root_path
  end
  
  def uninstall
    store_hash = store_hash_via_payload
    store = Store.find_by(owner_id: store_hash["user"]["id"])
    unless store.nil?
      unless store.amazon.nil?
        marketplace = store.amazon.marketplace
        seller_id = store.amazon.seller_id
        auth_token = store.amazon.auth_token
        create_subscription_client(marketplace, seller_id, auth_token)
        delete_sqs_subscription(marketplace)
      end
    end
    store.nil? ? Rails.logger.info("no store to destroy!") : store.destroy
    clear_session
    head :ok
  end

private

  def clear_session
    session[:fba_shipping_id] = nil
  end
  
  def set_bc_session_during_install(store)
    session[:fba_shipping_id] = store.id
  end

  
  def set_bc_session_during_load
    owner_id = store_hash_via_payload["user"]["id"]
    @loaded_store = Store.find_by(owner_id: owner_id)
    session[:fba_shipping_id] = @loaded_store.id
  end

  def get_access_token
    @send_to_bc = HTTParty.post("https://login.bigcommerce.com/oauth2/token", :query =>{
                  :client_id => ENV['BC_CLIENT_ID'],
                  :client_secret => ENV['BC_CLIENT_SECRET'],
                  :code => params["code"],
                  :scope => "store_cart store_v2_customers_login store_v2_default store_v2_information store_v2_orders store_v2_products store_v2_transactions",
                  :grant_type => "authorization_code",
                  :redirect_uri => "#{ENV['URL']}/auth/:name/callback",
                  :context => params["context"]
                  },
                  :headers => {"Content-Type" => "application/x-www-form-urlencoded"})
  end
  
  def get_bc_response_body
    @bc_response_body = JSON.parse(send_to_bc.response.body)
  end

  def get_store_info
    domain = bc_response_body['context'].split('/').last
    token = bc_response_body["access_token"]
    @store_hash = {domain: domain,
                  token: token,
                  shop_info: {
                              owner_email: bc_response_body["user"]["email"],
                              owner_id: bc_response_body["user"]["id"],
                              shop_name: domain
                              }
                  }
    @owner_id = bc_response_body["user"]["id"]
    get_store_currency_info(domain, token)
  end
  
  def get_store_currency_info(domain, token)
    store_info = HTTParty.get(
      "https://api.bigcommerce.com/stores/#{domain}/v2/store",
      :headers => create_headers_in_auth_controller(token))
    @currency_code = store_info["currency"]
    @currency_symbol = store_info["currency_symbol"]
  end
  
  def create_store
    @store || Store.create(owner_id: owner_id,
                token: store_hash[:token],
                bc_hash: store_hash[:domain],
                currency_code: currency_code,
                currency_symbol: currency_symbol
                )
  end
  
  def create_headers_in_auth_controller(token)
    { "X-Auth-Client"  => "#{ENV["BC_CLIENT_ID"]}",
      "X-Auth-Token" => token,
      "Accept" => "application/json",
      "Content-Type" => "application/json"}
  end

  
end