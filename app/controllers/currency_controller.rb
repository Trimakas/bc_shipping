class CurrencyController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  
  def return_currency_info
    render json: {currency_symbol: current_store.currency_symbol}
  end
  
end