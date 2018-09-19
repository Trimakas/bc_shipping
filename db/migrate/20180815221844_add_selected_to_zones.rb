class AddSelectedToZones < ActiveRecord::Migration[5.1]
  def change
    add_column :zones, :selected, :boolean, default: false
  end
end
