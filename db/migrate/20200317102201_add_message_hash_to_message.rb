class AddMessageHashToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :message_hash, :text
  end
end
