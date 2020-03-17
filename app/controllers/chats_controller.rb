class ChatsController < ApplicationController

  def index
      @user_id = current_user.id
  end

  def new_message
    message = params[:message]
    message_hash = Digest::MD5.hexdigest(message.downcase)
    user_to = User.find(params[:user_to])
    user_from_id = params[:user_from]
    conversation = user_to.current_conversation_id

    Message.create(user_id: user_from_id, message_text: message, conversation_id: conversation, message_hash: message_hash)
    
    UserChannel.broadcast_to(user_to, {body:"message", message_text:message})
  end

  def check_message
    message = params[:message]
    puts params[:message]
    message_hash = Digest::MD5.hexdigest(message.downcase)
    unless message.length == 0 || Message.where(message_hash: message_hash).exists?
      is_unique = true 
    else
      is_unique = false
    end
    puts is_unique
    respond_to do |format|
      format.json {render json: {is_unique: is_unique}}
    end
 

  end
end
