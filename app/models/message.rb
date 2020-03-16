class Message < ApplicationRecord
  belongs_to :user
  belongs_to :current_conversation, :class_name => "Conversation"
end
