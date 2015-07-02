class AddAttendantToCheckinUser < ActiveRecord::Migration
  def change
    add_reference :checkin_users, :attendant, references: :users, index: true
  end
end
