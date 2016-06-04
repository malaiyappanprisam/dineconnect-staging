class AddPaymentPreferenceToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :payment_preference, :integer
  end
end
