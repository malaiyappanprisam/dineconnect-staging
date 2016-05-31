class AddChannelGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :channel_group, :string
  end
end
