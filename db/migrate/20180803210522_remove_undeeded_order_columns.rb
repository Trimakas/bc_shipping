class RemoveUndeededOrderColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :arrival_time, :datetime
    remove_column :orders, :tracking_url, :string   
  end
end
