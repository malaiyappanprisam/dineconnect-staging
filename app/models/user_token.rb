class UserToken < ActiveRecord::Base
  belongs_to :user

  validates :device_id, uniqueness: {scope: :user}
end
