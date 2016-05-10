class AddNationalityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nationality, :string
  end
end
