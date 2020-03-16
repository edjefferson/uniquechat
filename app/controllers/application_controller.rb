class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    puts "app_control"
    if cookies[:user_id] && User.where(id: cookies[:user_id]).exists?
      User.find(cookies[:user_id])
    else
      user = User.create!
      cookies[:user_id] = user.id
      user
    end
  end
end
