class RemoveScope < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :bc_scope, :string
  end
end
