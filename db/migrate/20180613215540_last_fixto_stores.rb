class LastFixtoStores < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :access_token, :string
    remove_column :stores, :domain, :string
    add_column :stores, :owner_id, :string
    add_index :stores, :owner_id
  end
end
