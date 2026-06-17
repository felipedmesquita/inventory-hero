require "test_helper"

class TransferBatchItemTest < ActiveSupport::TestCase
  test "cannot add items to committed batch" do
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)
    batch_item = TransferBatchItem.new(
      transfer_batch: transfer_batches(:two),
      inventory_item: item,
      origin_location: item.location
    )

    assert_not batch_item.valid?
    assert_includes batch_item.errors[:transfer_batch], "must be draft"
  end
end
