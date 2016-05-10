class SetNotNullAndDefaultValueToUsers < ActiveRecord::Migration
  def change
    change_column :users, :residence_status, :integer, null: false, default: 0
    change_column :users, :interested_to_meet, :integer, null: false, default: 0
    change_column :users, :payment_preference, :integer, null: false, default: 0
  end
end
