require "test_helper"

class TransferTest < ActiveSupport::TestCase
  test "moves inventory item and records origin" do
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)

    transfer = Transfer.move!(inventory_item: item, destination_location: locations(:two))

    assert_equal locations(:one), transfer.origin_location
    assert_equal locations(:two), transfer.destination_location
    assert_equal locations(:two), item.reload.location
  end

  test "does not allow transfer to same location" do
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)

    transfer = Transfer.new(inventory_item: item, origin_location: locations(:one), destination_location: locations(:one))

    assert_not transfer.valid?
  end
end
