class AddStaffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :staff, :boolean, after: :admin
  end
end
