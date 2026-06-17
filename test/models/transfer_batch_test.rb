require "test_helper"

class TransferBatchTest < ActiveSupport::TestCase
  test "adds each inventory item once" do
    batch = TransferBatch.create!(destination_location: locations(:two))
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)

    assert_difference "TransferBatchItem.count", 1 do
      2.times { batch.add_item!(item) }
    end
  end

  test "commit moves all batch items and marks batch committed" do
    batch = TransferBatch.create!(destination_location: locations(:two))
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)
    batch.add_item!(item)

    assert_difference "Transfer.count", 1 do
      assert batch.commit!
    end

    assert_predicate batch.reload, :status_committed?
    assert_not_nil batch.committed_at
    assert_equal locations(:two), item.reload.location
  end

  test "commit is idempotent after batch is committed" do
    assert_no_difference "Transfer.count" do
      assert_equal false, transfer_batches(:two).commit!
    end
  end
end
