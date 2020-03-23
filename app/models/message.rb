class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  def check_if_can_be_sent

  end
end
