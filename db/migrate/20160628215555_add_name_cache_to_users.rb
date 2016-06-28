class AddNameCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name_cache, :string
  end
end
