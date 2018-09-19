class AddUniquenessToStore < ActiveRecord::Migration[5.1]
  def change
    remove_index :stores, :owner_id
    add_index :stores, :owner_id, unique: true
  end
end
