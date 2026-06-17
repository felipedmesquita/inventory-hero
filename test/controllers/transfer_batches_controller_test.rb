require "test_helper"

class TransferBatchesControllerTest < ActionDispatch::IntegrationTest
  test "gets new" do
    get new_transfer_batch_url

    assert_response :success
  end

  test "creates transfer batch from barcodes" do
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)

    assert_difference [ "TransferBatch.count", "TransferBatchItem.count" ], 1 do
      post transfer_batches_url, params: {
        transfer_batch: {
          destination_location_id: locations(:two).id,
          barcodes: item.barcode
        }
      }
    end

    assert_redirected_to transfer_batch_url(TransferBatch.last)
  end

  test "gets show" do
    get transfer_batch_url(transfer_batches(:one))

    assert_response :success
  end

  test "commits transfer batch" do
    batch = TransferBatch.create!(destination_location: locations(:two))
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)
    batch.add_item!(item)

    assert_difference "Transfer.count", 1 do
      post commit_transfer_batch_url(batch)
    end

    assert_redirected_to transfer_batch_url(batch)
    assert_equal locations(:two), item.reload.location
  end
end
