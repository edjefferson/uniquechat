class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_cookies
  
  def set_cookies
    cookies[:user_id] = current_user ?  current_user.id : nil
  end
end
