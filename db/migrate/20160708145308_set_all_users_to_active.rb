class SetAllUsersToActive < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.update(active: true)
    end
  end

  def down
  end
end
