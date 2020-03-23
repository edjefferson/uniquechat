class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user

    current_user.update(instances: current_user.instances + 1, last_appeared:Time.now)    
  end



  def away
    puts "gone away"
    current_user.update(instances: 0)
    terminate_conversation
  end

  def appear(data)
    current_user.update(last_appeared:Time.now)
  end



  def unsubscribed
    current_user.update(instances: 0)

    terminate_conversation

  end

  def terminate_conversation
    user = User.find(current_user.id)
    if current_user.instances == 0
      conversation = user.current_conversation

      puts "terminating conversation from #{conversation}"
      if conversation
        user_to = conversation.users.where.not(id: user.id)[0]
        user.update(current_conversation_id: nil)
        user_to.update(current_conversation_id: nil)
        UserChannel.broadcast_to(user_to, {body:"conversation_ended", time:Time.now})
      else
        puts "no conv"
      end
    end
      
  end
end
