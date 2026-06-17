require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "normalizes code before validation" do
    location = Location.new(name: "Shelf B1", code: " b1 ")

    assert location.valid?
    assert_equal "B1", location.code
  end

  test "requires unique code" do
    location = Location.new(name: "Duplicate", code: locations(:one).code.downcase)

    assert_not location.valid?
    assert_includes location.errors[:code], "has already been taken"
  end
end
