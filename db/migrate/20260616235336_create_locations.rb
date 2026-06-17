class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.boolean :inventory_counts, null: false, default: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :locations, :code, unique: true
    add_index :locations, :active
    add_index :locations, :inventory_counts
  end
end
