class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "AppearanceChannel"
    
    ActionCable.server.broadcast("AppearanceChannel", body: "new_user_logged_on", users: User.where(active:true).pluck(:id))
   
  end
 
  def unsubscribed
  end
 
  def appear(data)
  end
 
  def away
    ActionCable.server.broadcast("AppearanceChannel", body: "new_user_logged_off", users: User.where(active:true).pluck(:id))
  end
end
