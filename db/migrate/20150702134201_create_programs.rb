class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :key
      t.string :label

      t.timestamps null: false
    end
  end
end
