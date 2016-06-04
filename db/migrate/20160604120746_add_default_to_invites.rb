class AddDefaultToInvites < ActiveRecord::Migration
  def change
    Invite.where(payment_preference: nil).update_all(payment_preference: 0)
  end
end
