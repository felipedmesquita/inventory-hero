class CreateTransfers < ActiveRecord::Migration[8.1]
  def change
    create_table :transfers do |t|
      t.references :inventory_item, null: false, foreign_key: true
      t.references :origin_location, null: false, foreign_key: { to_table: :locations }
      t.references :destination_location, null: false, foreign_key: { to_table: :locations }
      t.text :note

      t.timestamps
    end

    add_index :transfers, :created_at
  end
end
