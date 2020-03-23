class ChatsController < ApplicationController


  def check_for_instances

    respond_to do |format|
      format.json {render json: {instances: current_user.instances}}
    end
    
  end
  
  def index
      @user_id = current_user.id
  end

  def connect_to_new_user
    test_mode = false
    unless test_mode
      available_users = User.where.not(id: ([current_user.id] + current_user.users_talked_to.ids).uniq).where("instances > 0").where(current_conversation_id: nil).order(last_appeared: :asc)
    else
      available_users = User.where.not(id:current_user.id).where("instances > 0").where(current_conversation_id: nil).order(last_appeared: :asc)
    end
    if available_users[0]
      second_user = available_users[0]
      conv = Conversation.create
      conv.users = [current_user, second_user]
      current_user.update(current_conversation_id: conv.id) 
      second_user.update(current_conversation_id: conv.id)

      UserChannel.broadcast_to(current_user, body: "chat_to_user_#{second_user.id}", my_turn: true)
      UserChannel.broadcast_to(second_user, body: "chat_to_user_#{current_user.id}", my_turn: false)
    end

    def disconnect_from_current_user
      conv = current_user.current_conversation
      if conv
        second_user = conv.users.where.not(id: current_user.id)[0]
        conv.users.update(current_conversation_id: conv.id)
        UserChannel.broadcast_to(second_user, body: "disconnect_from_user")
      end
    end
  end

 

  def new_message
    message = params[:message]
    message_hash = Digest::MD5.hexdigest(message.downcase)
    user_to = User.find(params[:user_to])
    user_from_id = params[:user_from]
    conversation = user_to.current_conversation
    if !conversation.messages.order(created_at: :desc)[0] || Time.now - conversation.messages.order(created_at: :desc)[0].created_at <= 60
      Message.create(user_id: user_from_id, message_text: message, conversation_id: conversation.id, message_hash: message_hash)
      UserChannel.broadcast_to(user_to, {body:"message", message_text:message})
    end
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
