# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180818173449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amazons", force: :cascade do |t|
    t.text "auth_token"
    t.text "marketplace"
    t.integer "store_id"
    t.boolean "three_speed"
    t.text "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "bc_order_id"
    t.string "tracking_number", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_id"
    t.string "order_status"
    t.string "carrier"
    t.string "sent_to_amazon", default: "false"
    t.string "amazon_order_id"
    t.boolean "fulfillable"
  end

  create_table "speeds", force: :cascade do |t|
    t.string "shipping_speed"
    t.boolean "fixed", default: false
    t.decimal "fixed_amount", precision: 5, scale: 2
    t.boolean "flex", default: false
    t.string "flex_dollar_or_percent"
    t.decimal "flex_amount", precision: 5, scale: 2
    t.boolean "free", default: false
    t.float "free_shipping_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_id"
    t.boolean "enabled", default: false
  end

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_id"
    t.boolean "setup", default: false
    t.text "token"
    t.string "webhook_id", default: [], array: true
    t.string "bc_hash"
    t.string "currency_symbol"
    t.string "currency_code"
    t.index ["owner_id"], name: "index_stores_on_owner_id", unique: true
  end

  create_table "zones", force: :cascade do |t|
    t.string "zone_name"
    t.integer "bc_zone_id"
    t.integer "store_id"
    t.boolean "selected", default: false
    t.index ["zone_name", "bc_zone_id", "store_id"], name: "index_zones_on_zone_name_and_bc_zone_id_and_store_id", unique: true
  end

  add_foreign_key "amazons", "stores"
  add_foreign_key "speeds", "stores"
  add_foreign_key "zones", "stores"
end
