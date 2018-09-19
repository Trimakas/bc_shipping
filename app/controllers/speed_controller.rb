class SpeedController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  attr_reader :shipping_speed, :flex, :fixed, :fixed_rate_amount, :flex_amount,
              :free_shipping_amount, :free, :flex_dollar_or_percent, :enabled
  
  def save_shipping_info
    parse_params(safe_params)
    save_or_update_speed
    head :ok
  end
  
  def delete_speed
    speed_to_delete = safe_params["speed_type"]
    saved_speed_to_delete = current_store.speeds.find_by(store_id: current_store.id, shipping_speed: speed_to_delete)
    unless saved_speed_to_delete.nil?
      saved_speed_to_delete.delete
    end
    head :ok
  end
  
  def return_speed_info
    speed_to_find = params["speed"]
    speed_to_return = current_store.speeds.find_by(shipping_speed: speed_to_find)
    render json: speed_to_return
  end
  
  def number_of_speeds_to_return
    render json: {three_speed: current_store.amazon.three_speed?}
  end
  
  private
  
  def parse_params(safe_params)
    @shipping_speed = safe_params[:speed_type]
    @enabled = safe_params[:speed_enabled]
    @flex = safe_params[:flex_enabled]
    @fixed = safe_params[:fixed_enabled]
    @fixed_rate_amount = safe_params[:fixed_rate_amount]
    @flex_amount = safe_params[:flex_above_or_below_amount]
    @free_shipping_amount = safe_params[:free_shipping_amount]
    @free = safe_params[:free_enabled]
    @flex_dollar_or_percent = safe_params[:percent_or_dollar]
  end
  
  def save_or_update_speed
    current_speed = current_store.speeds.where(store_id: current_store.id, shipping_speed: shipping_speed)
    if current_speed.empty?
      current_store.speeds.create(
        shipping_speed: shipping_speed,
        enabled: enabled,
        flex: flex,
        fixed: fixed,
        free: free,
        fixed_amount: fixed_rate_amount,
        flex_amount: flex_amount,
        free_shipping_amount: free_shipping_amount,
        flex_dollar_or_percent: flex_dollar_or_percent)
    else
      current_store.speeds.update(
        shipping_speed: shipping_speed,
        enabled: enabled,
        flex: flex,
        fixed: fixed,
        free: free,
        fixed_amount: fixed_rate_amount,
        flex_amount: flex_amount,
        free_shipping_amount: free_shipping_amount,
        flex_dollar_or_percent: flex_dollar_or_percent)
    end
  end
  
  def safe_params
    params.require(:bytestand_rate_info)
  end
  
end