class CreateTableAmazon < ActiveRecord::Migration[5.1]
  def change
    create_table :amazons do |t|
      t.text "auth_token"
      t.text "marketplace"
      t.integer "store_id"
      t.boolean "three_speed"
      t.text "seller_id"
    end
    add_foreign_key :amazons, :stores
  end

end
