class CreateCheckinSessions < ActiveRecord::Migration
  def change
    create_table :checkin_sessions do |t|
      t.string :key
      t.string :label
      t.references :checkin_session_type, index: true, foreign_key: true
      t.datetime :check_in_by

      t.timestamps null: false
    end
  end
end
