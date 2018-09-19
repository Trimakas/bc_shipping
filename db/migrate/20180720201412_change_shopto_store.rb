class ChangeShoptoStore < ActiveRecord::Migration[5.1]
  def change
    remove_column :zones, :shop_id, :integer
    add_column :zones, :store_id, :integer
    add_foreign_key :zones, :stores
  end
end
