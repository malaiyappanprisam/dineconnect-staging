class AddFullNameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :full_name, :string

    User.all.each do |user|
      user.save
    end
  end

  def down
    remove_column :users, :full_name
  end
end
