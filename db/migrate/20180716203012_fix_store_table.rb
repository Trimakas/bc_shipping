class FixStoreTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :store_hash, :jsonb
    add_column :stores, :token, :text
    add_column :stores, :hash, :string
    add_column :stores, :webhook_id, :string, array:true, default: []
  end
end
