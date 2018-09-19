class AddIndexToZones < ActiveRecord::Migration[5.1]
  def change
    add_index :zones, [:zone_name, :bc_zone_id, :store_id], unique: true
  end
end
