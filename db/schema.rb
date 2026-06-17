# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_16_235340) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "inventory_items", force: :cascade do |t|
    t.string "barcode", null: false
    t.datetime "created_at", null: false
    t.date "expiration_date"
    t.string "gtin"
    t.bigint "location_id", null: false
    t.bigint "product_id", null: false
    t.integer "sequence_number", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["barcode"], name: "index_inventory_items_on_barcode", unique: true
    t.index ["expiration_date"], name: "index_inventory_items_on_expiration_date"
    t.index ["location_id"], name: "index_inventory_items_on_location_id"
    t.index ["product_id", "sequence_number"], name: "index_inventory_items_on_product_id_and_sequence_number", unique: true
    t.index ["product_id"], name: "index_inventory_items_on_product_id"
    t.index ["status"], name: "index_inventory_items_on_status"
  end

  create_table "locations", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.boolean "inventory_counts", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_locations_on_active"
    t.index ["code"], name: "index_locations_on_code", unique: true
    t.index ["inventory_counts"], name: "index_locations_on_inventory_counts"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.boolean "requires_expiration_date", default: false, null: false
    t.boolean "requires_gtin", default: false, null: false
    t.string "sku", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_products_on_active"
    t.index ["sku"], name: "index_products_on_sku", unique: true
  end

  create_table "transfer_batch_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "inventory_item_id", null: false
    t.bigint "origin_location_id", null: false
    t.bigint "transfer_batch_id", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_item_id"], name: "index_transfer_batch_items_on_inventory_item_id"
    t.index ["origin_location_id"], name: "index_transfer_batch_items_on_origin_location_id"
    t.index ["transfer_batch_id", "inventory_item_id"], name: "idx_on_transfer_batch_id_inventory_item_id_7b55d43483", unique: true
    t.index ["transfer_batch_id"], name: "index_transfer_batch_items_on_transfer_batch_id"
  end

  create_table "transfer_batches", force: :cascade do |t|
    t.datetime "committed_at"
    t.datetime "created_at", null: false
    t.bigint "destination_location_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["destination_location_id"], name: "index_transfer_batches_on_destination_location_id"
    t.index ["status"], name: "index_transfer_batches_on_status"
  end

  create_table "transfers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "destination_location_id", null: false
    t.bigint "inventory_item_id", null: false
    t.text "note"
    t.bigint "origin_location_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_transfers_on_created_at"
    t.index ["destination_location_id"], name: "index_transfers_on_destination_location_id"
    t.index ["inventory_item_id"], name: "index_transfers_on_inventory_item_id"
    t.index ["origin_location_id"], name: "index_transfers_on_origin_location_id"
  end

  add_foreign_key "inventory_items", "locations"
  add_foreign_key "inventory_items", "products"
  add_foreign_key "transfer_batch_items", "inventory_items"
  add_foreign_key "transfer_batch_items", "locations", column: "origin_location_id"
  add_foreign_key "transfer_batch_items", "transfer_batches"
  add_foreign_key "transfer_batches", "locations", column: "destination_location_id"
  add_foreign_key "transfers", "inventory_items"
  add_foreign_key "transfers", "locations", column: "destination_location_id"
  add_foreign_key "transfers", "locations", column: "origin_location_id"
end
