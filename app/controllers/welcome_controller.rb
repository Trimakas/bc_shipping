class WelcomeController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token


  def index
  end
  
  def where_to_send_user
    where_to_go = 'welcome'
    if current_store.setup
      where_to_go = 'speeds'
    else
      where_to_go = 'welcome'
    end
    render json: where_to_go
  end

end