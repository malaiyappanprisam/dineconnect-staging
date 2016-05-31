class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invitee, class_name: "User"

  validates :user_id, uniqueness: { scope: :invitee_id }
  validates :invitee, presence: true
  validates :user, presence: true
  before_create :fill_channel_group_for_user

  private

  def fill_channel_group_for_user
    user.try(:generate_channel_group)
  end
end
