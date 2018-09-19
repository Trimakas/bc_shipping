module SqsConcern
extend ActiveSupport::Concern
include ApplicationConcern

attr_reader :amazon_client

  def create_subscription_client(marketplace, seller_id, auth_token)
    keys = which_amazon_keys_to_use?(marketplace)
    @amazon_client = MWS::Subscriptions::Client.new(
                    marketplace:           "#{marketplace}",
                    merchant_id:           "#{seller_id}",
                    aws_access_key_id:     "#{keys[:access_key]}",
                    aws_secret_access_key: "#{keys[:secret_access_key]}",
                    auth_token:            "#{auth_token}")
  end
  
  def already_registered_with_sqs?(marketplace)
    !amazon_client.list_registered_destinations(marketplace).parse["DestinationList"].nil?
  end
  
  def already_subscribed_to_sqs?(marketplace)
    !amazon_client.list_subscriptions(marketplace).parse["SubscriptionList"].nil?
  end
  
  def register_sqs_destination(marketplace)
    unless already_registered_with_sqs?(marketplace)
      amazon_client.register_destination(ENV['sqs_url'], marketplace_id = marketplace )
    end
  end
  
  def create_sqs_subscription(marketplace)
    unless already_subscribed_to_sqs?(marketplace) 
      amazon_client.create_subscription("FulfillmentOrderStatus", ENV['sqs_url'], marketplace_id = marketplace)
    end
  end

  def delete_sqs_subscription(marketplace)
    amazon_client.delete_subscription("FulfillmentOrderStatus", ENV['sqs_url'], marketplace_id = marketplace)
    amazon_client.deregister_destination(ENV['sqs_url'], marketplace_id = marketplace)
  end
  
end