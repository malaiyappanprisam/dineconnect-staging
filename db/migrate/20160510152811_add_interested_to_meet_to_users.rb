class AddInterestedToMeetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :interested_to_meet, :integer
  end
end
