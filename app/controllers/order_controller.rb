class OrderController < ApplicationController
  skip_before_action :verify_authenticity_token
  attr_reader :bc_shipping_address, :order_id, :store, :hook_still_active
  include OrderConcern
  
  
  def receive_order_update #this is going to get hit twice
    if should_we_process_order?
      what_to_do_with_order(order_params, store, get_products, get_shipping_address)
      head :ok
    else
      head :ok
    end
    unless hook_still_active
      head :bad_request
    end
  end
  
  private
  
    def should_we_process_order?
      should_we = []
      should_we << webhook_duplicate?
      @hook_still_active = webhook_still_active?
      should_we << hook_still_active
      should_we << is_order_bytestand?
      should_we << do_we_need_to_update_order_in_db?
      !should_we.include?(false) #this says if any of these return false, then we should not process the order
    end
    
    def do_we_need_to_update_order_in_db?
      db_order = Order.find_by(bc_order_id: get_order_id)
      unless db_order.nil?
        db_order_status = db_order.order_status
        bc_order_status = Bigcommerce::Order.find(get_order_id, connection: create_bc_connection_with_store(get_store)).status.downcase
        !(db_order_status == bc_order_status)
      else
        return true
      end
    end
  
    def webhook_duplicate? #this ignores the new order webhook hit thats a dup
      order_params["data"].has_key?("status")
    end
  
    def webhook_still_active?
      !get_store.nil?
    end
    
    def is_order_bytestand?
      bc_shipping_address = get_shipping_address
      shipping_method = bc_shipping_address[0].shipping_method
      shipping_method.include?("ByteStand")
    end
    
    def get_store
      producer = order_params["producer"]
      domain = producer.sub(/^stores\//, '')
      @store ||= Store.find_by(bc_hash: domain)
    end
  
    def get_order_id
      order_params["data"]["id"]
    end
    
    def get_shipping_address
      @address ||= Bigcommerce::OrderShippingAddress.all(get_order_id, connection: create_bc_connection_with_store(get_store))
    end
    
    def get_products
      @products ||= Bigcommerce::OrderProduct.all(get_order_id, connection: create_bc_connection_with_store(store))
    end
    
    def order_params
      params.permit(:producer, data: {})
    end
    

end