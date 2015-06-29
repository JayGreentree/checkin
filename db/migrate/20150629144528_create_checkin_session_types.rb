class CreateCheckinSessionTypes < ActiveRecord::Migration
  def change
    create_table :checkin_session_types do |t|
      t.string :key
      t.string :label

      t.timestamps null: false
    end
  end
end
