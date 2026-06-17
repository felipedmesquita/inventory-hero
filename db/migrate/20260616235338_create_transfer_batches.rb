class CreateTransferBatches < ActiveRecord::Migration[8.1]
  def change
    create_table :transfer_batches do |t|
      t.references :destination_location, null: false, foreign_key: { to_table: :locations }
      t.integer :status, null: false, default: 0
      t.datetime :committed_at

      t.timestamps
    end

    add_index :transfer_batches, :status
  end
end
