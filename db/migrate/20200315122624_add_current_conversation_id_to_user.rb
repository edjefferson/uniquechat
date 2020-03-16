class AddCurrentConversationIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_conversation_id, :integer
  end
end
