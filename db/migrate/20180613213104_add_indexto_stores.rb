class AddIndextoStores < ActiveRecord::Migration[5.1]
  def change
    add_index :stores, :domain
  end
end
