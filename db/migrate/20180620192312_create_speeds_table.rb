class CreateSpeedsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :speeds do |t|
      t.string  "shipping_speed"     
      t.boolean  "fixed", default: false
      t.decimal  "fixed_amount", precision: 5, scale: 2      
      t.boolean  "flex", default: false
      t.string   "flex_dollar_or_percent"
      t.decimal  "flex_amount", precision: 5, scale: 2
      t.boolean  "free",                                          default: false
      t.float    "free_shipping_amount"
      t.datetime "created_at",                                                    null: false
      t.datetime "updated_at",                                                    null: false
      t.integer  "shop_id"
    end
  end
end