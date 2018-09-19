class AddTimeToAmazons < ActiveRecord::Migration[5.1]
  def change
    add_column :amazons, :created_at, :datetime, null: false
    add_column :amazons, :updated_at, :datetime, null: false    
  end
end
