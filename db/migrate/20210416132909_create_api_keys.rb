class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.integer :bearer_id, null: false
      t.string :bearer_type, null: false
      t.string :token_digest, null: false
      t.timestamps null: false
    end

    add_index :api_keys, [:bearer_id, :bearer_type]
    add_index :api_keys, :token_digest, unique: true
  end
end
