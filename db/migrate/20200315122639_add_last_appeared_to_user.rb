class AddLastAppearedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_appeared, :timestamp
  end
end
