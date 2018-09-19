class AddSetuptoStore < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :setup, :boolean, default: false
  end
end
