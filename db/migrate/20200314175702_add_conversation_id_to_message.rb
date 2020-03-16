class AddConversationIdToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :conversation_id, :integer
  end
end
