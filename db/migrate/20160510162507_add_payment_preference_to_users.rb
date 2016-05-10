class AddPaymentPreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payment_preference, :integer
  end
end
