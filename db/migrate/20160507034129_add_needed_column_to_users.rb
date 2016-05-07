class AddNeededColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :gender, :integer, default: 0, null: false
    add_column :users, :date_of_birth, :date
    add_column :users, :profession, :string
  end
end
