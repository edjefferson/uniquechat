class User < ApplicationRecord
  has_many :messages
  has_many :conversations
  belongs_to :current_conversation, class_name: 'Conversation', optional: true
end
