class Conversation < ApplicationRecord
  has_many :messages
  belongs_to :user_1, :class_name => "User"
  belongs_to :user_2, :class_name => "User"

  def other_user(user)
    user_1 == user ? user_2 : user_1
  end
end
