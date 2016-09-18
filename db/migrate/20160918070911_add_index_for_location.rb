class AddIndexForLocation < ActiveRecord::Migration
  def change
    add_index :restaurants, :location, using: :gist
    add_index :users, :location, using: :gist
  end
end
