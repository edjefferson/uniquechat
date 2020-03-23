class AdminController < ApplicationController

  def index
    @users = User.order(:id)
  end

end
