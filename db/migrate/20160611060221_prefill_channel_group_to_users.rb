class PrefillChannelGroupToUsers < ActiveRecord::Migration
  def up
    User.where(channel_group: nil).find_each do |user|
      user.generate_channel_group
    end
  end

  def down
  end
end
