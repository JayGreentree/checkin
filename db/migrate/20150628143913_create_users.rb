class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :andrewid
      t.string :dorm
      t.string :room
      t.string :cell_number
      t.references :partner, index: true
      t.string :title
      t.boolean :admin

      t.timestamps null: false
    end
  end
end
