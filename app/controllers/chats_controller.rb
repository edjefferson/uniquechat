class ChatsController < ApplicationController

  def index
      @user_id = current_user.id
  end

  def new_message
    user_to = User.find(params[:user_to])
    UserChannel.broadcast_to(user_to, {body:"egg"})

  end
end
