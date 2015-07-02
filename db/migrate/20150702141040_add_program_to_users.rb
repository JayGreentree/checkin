class AddProgramToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :program, index: true, foreign_key: true
  end
end
