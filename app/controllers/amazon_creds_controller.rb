class AmazonCredsController < ApplicationController
  include AmazonCredsConcern
  include SqsConcern
  include ApplicationConcern
  include WebhookConcern
  skip_before_action :verify_authenticity_token
  attr_reader :marketplace, :seller_id, :auth_token, :client_status

  def amazon_credentials_check
    parse_params
    amazon_client = create_amazon_client(marketplace, seller_id, auth_token)
    @client_status = is_amazon_client_good?(amazon_client)
    if client_status
      save_amazon_creds_and_setup_sqs
      setup_order_webhook
      save_webhooks
    end
      render json: {are_the_amazon_creds_good: client_status}
  end
  
  def return_amazon_credentials
    if !(current_store.amazon.nil?)
      auth_token = current_store.amazon.auth_token
      seller_id = current_store.amazon.seller_id
      marketplace = current_store.amazon.marketplace
      zones = []
      current_store.zones.each do |zone|
       zones << {name: zone.zone_name, id: zone.bc_zone_id}
      end
      amazon_credentials = {auth_token: auth_token, seller_id: seller_id, marketplace: marketplace, zones: zones}.to_json
      render json: amazon_credentials
    else
      empty_credentials = {seller_id: ""}.to_json
      render json: empty_credentials
    end
  end
  
  private
  
  def parse_params
    @marketplace = params["marketplace"].upcase
    @seller_id = params["seller_id"].upcase
    @auth_token = params["auth_token"].downcase
  end
  
  def save_amazon_creds_and_setup_sqs
    save_amazon_creds(marketplace, seller_id, auth_token)
    update_store_setup
    sqs_create_and_register
  end
  
  def sqs_create_and_register
    create_subscription_client(marketplace, seller_id, auth_token)
    register_sqs_destination(marketplace)
    create_sqs_subscription(marketplace)
  end
  
end