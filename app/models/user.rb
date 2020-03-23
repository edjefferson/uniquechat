class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :messages

  has_and_belongs_to_many :conversations

  has_many :users_talked_to, through: :conversations, source: :users

  belongs_to :current_conversation, class_name: 'Conversation', optional: true
end
