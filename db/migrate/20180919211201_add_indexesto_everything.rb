class AddIndexestoEverything < ActiveRecord::Migration[5.1]
  def change
    add_index :speeds, [:store_id, :shipping_speed], unique: true
    add_index :orders, :bc_order_id, unique: true
    add_index :amazons, :store_id, unique: true
  end
end
