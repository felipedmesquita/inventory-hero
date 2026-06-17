class CreateTransferBatchItems < ActiveRecord::Migration[8.1]
  def change
    create_table :transfer_batch_items do |t|
      t.references :transfer_batch, null: false, foreign_key: true
      t.references :inventory_item, null: false, foreign_key: true
      t.references :origin_location, null: false, foreign_key: { to_table: :locations }

      t.timestamps
    end

    add_index :transfer_batch_items, [ :transfer_batch_id, :inventory_item_id ], unique: true
  end
end
