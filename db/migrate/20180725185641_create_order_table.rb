class CreateOrderTable < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string   "bc_order_id"
      t.string   "tracking_number",  default: [],                   array: true
      t.datetime "created_at",                         null: false
      t.datetime "updated_at",                         null: false
      t.integer  "store_id"
      t.string   "order_status"
      t.datetime "arrival_time"
      t.string   "carrier"
      t.string   "tracking_url",     default: [],                   array: true
      t.string   "sent_to_amazon",   default: "false"
      t.string   "amazon_order_id"
      t.boolean  "fulfillable"
    end
  end
end
