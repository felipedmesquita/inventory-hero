require "test_helper"

class InventoryItemTest < ActiveSupport::TestCase
  test "assigns next sequence number and barcode from product sku" do
    item = InventoryItem.new(product: products(:one), location: locations(:one))

    assert item.valid?
    assert_equal "ABC-001-000002", item.barcode
    assert_equal 2, item.sequence_number
  end

  test "requires sequence number to be unique per product" do
    item = InventoryItem.new(product: products(:one), location: locations(:one), sequence_number: inventory_items(:one).sequence_number)

    assert_not item.valid?
    assert_includes item.errors[:sequence_number], "has already been taken"
  end

  test "allows the same sequence number for different products" do
    item = InventoryItem.new(product: products(:two), location: locations(:one), sequence_number: 2)

    assert item.valid?
  end

  test "does not override explicitly assigned sequence number" do
    item = InventoryItem.new(product: products(:one), location: locations(:one), sequence_number: 10)

    assert item.valid?
    assert_equal "ABC-001-000010", item.barcode
  end

  test "detects missing required details" do
    item = InventoryItem.new(product: products(:two), location: locations(:one), sequence_number: 2)

    assert item.missing_required_details?
  end

  test "moves through transfer history" do
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)

    assert_difference "Transfer.count", 1 do
      item.move_to!(locations(:two), note: "Put away")
    end

    assert_equal locations(:two), item.reload.location
    assert_equal "Put away", item.transfers.last.note
  end
end
