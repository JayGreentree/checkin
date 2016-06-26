class AddArrivalDateAndDepartureDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :arrives_on, :date
    add_column :users, :departs_on, :date
  end
end
