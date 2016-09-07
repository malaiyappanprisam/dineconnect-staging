class AddOnboardToUsers < ActiveRecord::Migration
  def up
    add_column :users, :onboard, :boolean, default: false
    User.all.each do |user|
      user.update(onboard: true)
    end
  end

  def down
  end
end
