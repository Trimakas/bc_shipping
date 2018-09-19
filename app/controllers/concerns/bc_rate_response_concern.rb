module BCRateResponseConcern
  extend ActiveSupport::Concern
  include ApplicationConcern
  
  attr_reader :rate_quotes
  
  def prep_bc_rate_response(parsed_amazon_rates)
    @rate_quotes = []
    parsed_amazon_rates.each do |speed|
      @rate_quotes << {code: "#{rand(0..200)}x",
                      display_name: speed[:speed],
                      cost: {
                        currency: speed[:currency],
                        amount: speed[:amount]
                      }
                      # transit_time: {
                      #   units: "DAYS",
                      #   duration: speed[:transit_duration]
                      # }
                    }
    end
  end
  
  def bc_rate_response
    {
      quote_id: "fba_shipping",
      messages: [],
    	carrier_quotes: [{
    			carrier_info: {
    				code: "bytestand",
    				display_name: "FBA Shipping"
    			},
    			quotes: rate_quotes
    		}],
    }
  end
  
  def bc_rate_response_when_no_amazon_response
    {
      quote_id: "fba_shipping",
      messages: [],
    	carrier_quotes: [{
    			carrier_info: {
    				code: "bytestand",
    				display_name: "FBA Shipping"
    			},
    			quotes: []
    		}],
    }
  end

end

