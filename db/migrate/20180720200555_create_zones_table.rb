class CreateZonesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :zones do |t|
      t.string :zone_name
      t.integer :bc_zone_id
      t.integer :shop_id
    end
  end
end
