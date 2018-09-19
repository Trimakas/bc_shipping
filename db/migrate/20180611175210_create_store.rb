class CreateStore < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.string   "store_hash"
      t.string   "access_token"
      t.string   "bc_scope"
      t.string   "username"
      t.string   "email"
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
      t.string   "user_id"
    end
  end
end
