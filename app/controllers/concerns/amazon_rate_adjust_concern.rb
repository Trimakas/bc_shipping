module AmazonRateAdjustConcern
  extend ActiveSupport::Concern
  include ApplicationConcern
  SPEEDS = ["Standard", "Priority", "Expedited"]
  attr_reader :parsed_amazon_rates, :current_speeds, :shop, :speed_details, :cart_amount
  
  def adjust_amazon_rates(parsed_amazon_rates, cart_amount)
    initialize_variables(parsed_amazon_rates, cart_amount)
    which_speeds_are_enabled_in_db?
    remove_non_enabled_speeds
    get_enabled_speeds_from_db
    get_enabled_speed_details_that_are_true
    return @parsed_amazon_rates
  end
  
  def initialize_variables(parsed_amazon_rates, cart_amount)
    @parsed_amazon_rates = parsed_amazon_rates
    @shop = get_store_via_params(my_params)
    @cart_amount = cart_amount
  end
  
  def which_speeds_are_enabled_in_db? #this returns a simple array with the speed names listed
    @current_speeds = []
    SPEEDS.each do |speed|  
      if shop.speeds.include?(Speed.find_by(shipping_speed: speed, enabled: true))
        current_speeds << speed
      end
    end
  end
  
  def remove_non_enabled_speeds
    speed_to_remove = SPEEDS - current_speeds
    speed_to_remove.each do |speed_getting_deleted|
      parsed_amazon_rates.delete_if{|speed| speed[:speed] == speed_getting_deleted}
    end
  end
  
  def get_enabled_speeds_from_db #this queries the db with the enabled speeds from above
    @speed_details = []
    current_speeds.each do |speed|
      @speed_details << shop.speeds.find_by(shipping_speed: speed)
    end
  end
  
  def get_enabled_speed_details_that_are_true #this gets all the details that are true each speed
    speed_details.each do |speed|
      speed_name = {speed: speed[:shipping_speed]}
      whats_turned_on = speed.attributes.select{|k,v| v == true }
      walk_thru_each_rate_type(speed_name.merge(whats_turned_on),speed)
    end
  end
  
  def walk_thru_each_rate_type(speed_hash, speed_from_db)
    if speed_hash.has_key?("flex")
      handle_flex_rates(speed_from_db)
    end
    if speed_hash.has_key?("fixed")
      handle_fixed_rates(speed_from_db)
    end
    if speed_hash.has_key?("free")
      handle_free_shipping(speed_from_db)
    end
  end
  
  def handle_flex_rates(speed_from_db)
    dollar_or_percent = speed_from_db[:flex_dollar_or_percent]
    flex_amount = speed_from_db[:flex_amount]
    speed = speed_from_db[:shipping_speed]
    parsed_amazon_rates.each do |rate|
      if rate.has_value?(speed)
        rate[:amount] = dollar_or_percent == "$" ? rate[:amount] = rate[:amount].to_f + flex_amount.to_f : rate[:amount] = rate[:amount].to_f * (1 + (flex_amount.to_f/100))
      end
    end
  end
  
  def handle_fixed_rates(speed_from_db)
    fixed_amount = speed_from_db[:fixed_amount]
    speed = speed_from_db[:shipping_speed]
    parsed_amazon_rates.each do |rate|
      if rate.has_value?(speed)
        rate[:amount] = fixed_amount
      end
    end
  end

  def handle_free_shipping(speed_from_db)
    free_shipping_amount = speed_from_db.free_shipping_amount
    speed = speed_from_db[:shipping_speed]
    parsed_amazon_rates.each do |rate|
      if rate.has_value?(speed)
        if cart_amount >= free_shipping_amount
          rate[:amount] = 0
        end
      end
    end
  end
  
  def my_params
    params.require(:base_options)
  end

end