class AddResidenceStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :residence_status, :integer
  end
end
