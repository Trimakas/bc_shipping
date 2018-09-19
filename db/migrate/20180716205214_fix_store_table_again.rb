class FixStoreTableAgain < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :hash, :string
    add_column :stores, :bc_hash, :string
  end
end
