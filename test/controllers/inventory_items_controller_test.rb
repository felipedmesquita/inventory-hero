require "test_helper"

class InventoryItemsControllerTest < ActionDispatch::IntegrationTest
  test "gets index" do
    get inventory_items_url

    assert_response :success
  end

  test "gets show" do
    get inventory_item_url(inventory_items(:one))

    assert_response :success
  end

  test "gets new" do
    get new_inventory_item_url

    assert_response :success
  end

  test "creates inventory item" do
    assert_difference "InventoryItem.count", 1 do
      post inventory_items_url, params: {
        inventory_item: {
          product_id: products(:one).id,
          location_id: locations(:one).id,
          sequence_number: 2,
          status: "available"
        }
      }
    end

    assert_redirected_to inventory_item_url(InventoryItem.last)
  end

  test "moves inventory item" do
    item = InventoryItem.create!(product: products(:one), location: locations(:one), sequence_number: 2)

    assert_difference "Transfer.count", 1 do
      post move_inventory_item_url(item), params: {
        destination_location_id: locations(:two).id,
        note: "Move from controller"
      }
    end

    assert_redirected_to inventory_item_url(item)
    assert_equal locations(:two), item.reload.location
  end
end
