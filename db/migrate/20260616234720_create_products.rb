class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :sku, null: false
      t.string :name, null: false
      t.text :description
      t.boolean :requires_gtin, null: false, default: false
      t.boolean :requires_expiration_date, null: false, default: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :active
  end
end
