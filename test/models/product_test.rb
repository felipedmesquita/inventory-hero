require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "normalizes sku before validation" do
    product = Product.new(sku: " abc-003 ", name: "New product")

    assert product.valid?
    assert_equal "ABC-003", product.sku
  end

  test "requires unique sku" do
    product = Product.new(sku: products(:one).sku.downcase, name: "Duplicate")

    assert_not product.valid?
    assert_includes product.errors[:sku], "has already been taken"
  end

  test "destroys inventory items with product" do
    product = Product.create!(sku: "ABC-004", name: "Temporary product")
    InventoryItem.create!(product:, location: locations(:one), sequence_number: 1)

    assert_difference "InventoryItem.count", -1 do
      product.destroy!
    end
  end
end
