class RemoveUserIdFromStores < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :user_id, :string
    add_column :stores, :domain, :text, index: true
  end
end
