class CreateCheckinUsers < ActiveRecord::Migration
  def change
    create_table :checkin_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :checkin_session, index: true, foreign_key: true
      t.datetime :checked_in_at

      t.timestamps null: false
    end
  end
end
