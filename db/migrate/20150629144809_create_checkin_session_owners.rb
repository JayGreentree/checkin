class CreateCheckinSessionOwners < ActiveRecord::Migration
  def change
    create_table :checkin_session_owners do |t|
      t.references :user, index: true, foreign_key: true
      t.references :checkin_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
