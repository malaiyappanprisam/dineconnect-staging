class CreateUserTokens < ActiveRecord::Migration
  def change
    create_table :user_tokens do |t|
      t.string :token
      t.references :user
      t.string :device_id

      t.timestamps null: false
    end
  end
end
