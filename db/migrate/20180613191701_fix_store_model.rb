class FixStoreModel < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :store_hash, :string
    add_column :stores, :store_hash, :jsonb, default: '{}', null: false
    remove_column :stores, :email, :string
    remove_column :stores, :username, :string    
  end
end
