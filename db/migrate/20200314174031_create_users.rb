class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.text :unique_hash

      t.timestamps
    end
  end
end
