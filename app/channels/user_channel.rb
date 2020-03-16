class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    puts "egg"
    current_user.update(active: true, last_appeared:Time.now)
    
    available_users = User.where.not(id:current_user.id).where(active:true, current_conversation_id: nil).order(last_appeared: :asc)
    if available_users[0]
      puts "egg"
      second_user = available_users[0]
      conv = Conversation.create(user_1_id: current_user.id, user_2_id: available_users[0].id)
      current_user.update(current_conversation_id: conv.id) 
      second_user.update(current_conversation_id: conv.id)

      UserChannel.broadcast_to(current_user, body: "chat_to_user_#{available_users[0].id}")

      UserChannel.broadcast_to(available_users[0], body: "chat_to_user_#{current_user.id}")

    end
  end

  def appear(data)
    current_user.update(active: true, last_appeared:Time.now)
  end



  def unsubscribed
    conversation = current_user.current_conversation
    conversation.user_1.update(current_conversation_id: nil)
    conversation.user_2.update(current_conversation_id: nil)
    current_user.update(active: false)
  end
end
