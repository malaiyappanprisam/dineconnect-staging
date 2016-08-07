class AddMirrorInviteOnAccepted < ActiveRecord::Migration
  def up
    Invite.where(status: Invite.statuses[:accept], initiator: true).each do |invite|
      Invite.create!(user: invite.invitee, invitee: invite.user, status: :accept,
                     restaurant: invite.restaurant, payment_preference: invite.payment_preference,
                     initiator: false)
    end
  end

  def down
  end
end
