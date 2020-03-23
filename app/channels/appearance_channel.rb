class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "AppearanceChannel"   
  end
 
  def unsubscribed
  end
 
  def appear(data)
  end
 
  def away
  end
end
