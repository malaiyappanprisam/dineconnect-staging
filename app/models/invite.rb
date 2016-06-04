class Invite < ActiveRecord::Base
  enum status: [:pending, :accept, :reject]
  enum payment_preference: [:anything_goes, :paying, :not_paying, :split_bill]

  belongs_to :user
  belongs_to :invitee, class_name: "User"
  belongs_to :restaurant

  validates :user_id, uniqueness: { scope: :invitee_id }
  validates :invitee, presence: true
  validates :user, presence: true
  validate :freeze_status_accept_or_reject
  before_create :fill_channel_group_for_user

  private

  def fill_channel_group_for_user
    user.try(:generate_channel_group)
  end

  def freeze_status_accept_or_reject
    if status_changed? && (status_was == "accept" || status_was == "reject")
      errors.add(:status, "Can't change accepted or rejected status")
    end
  end
end
