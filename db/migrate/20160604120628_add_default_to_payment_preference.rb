class AddDefaultToPaymentPreference < ActiveRecord::Migration
  def change
    change_column :invites, :payment_preference, :integer, null: false, default: 0
  end
end
