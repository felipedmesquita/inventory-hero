class CreateInventoryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_items do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :sequence_number, null: false
      t.string :barcode, null: false
      t.string :gtin
      t.date :expiration_date
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :inventory_items, :barcode, unique: true
    add_index :inventory_items, [ :product_id, :sequence_number ], unique: true
    add_index :inventory_items, :status
    add_index :inventory_items, :expiration_date
  end
end
