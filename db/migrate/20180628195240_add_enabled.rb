class AddEnabled < ActiveRecord::Migration[5.1]
  def change
    add_column :speeds, :enabled, :boolean, default: false
  end
end
