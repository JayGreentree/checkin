class AddExcusedToCheckinUser < ActiveRecord::Migration
  def change
    add_column :checkin_users, :excused, :boolean
  end
end
