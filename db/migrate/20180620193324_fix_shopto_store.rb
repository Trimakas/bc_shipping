class FixShoptoStore < ActiveRecord::Migration[5.1]
  def change
    remove_column :speeds, :shop_id, :integer
    add_column :speeds, :store_id, :integer
    add_foreign_key :speeds, :stores
  end
end
