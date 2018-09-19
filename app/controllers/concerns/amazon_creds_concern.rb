module AmazonCredsConcern
extend ActiveSupport::Concern
include ApplicationConcern
  
  def is_amazon_client_good?(amazon_client)
    begin
      amazon_client.list_all_fulfillment_orders.parse
    rescue StandardError
      false
    else
      true
    end
  end
  
  def save_amazon_creds(marketplace, seller_id, auth_token)
    current_store.amazon || current_store.create_amazon(seller_id: seller_id,
                                                        marketplace: marketplace,
                                                        auth_token: auth_token,
                                                        store_id: current_store.id,
                                                        three_speed: three_speeds?(marketplace))
  end
  
  def three_speeds?(marketplace)
    marketplace == "ATVPDKIKX0DER"
  end
  
  def update_store_setup
    current_store.update_attributes(setup: true)
  end

end