require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  test "gets index" do
    get locations_url

    assert_response :success
  end

  test "gets show" do
    get location_url(locations(:one))

    assert_response :success
  end

  test "gets new" do
    get new_location_url

    assert_response :success
  end

  test "creates location" do
    assert_difference "Location.count", 1 do
      post locations_url, params: {
        location: {
          code: "B2",
          name: "Shelf B2",
          inventory_counts: "1",
          active: "1"
        }
      }
    end

    assert_redirected_to location_url(Location.last)
  end
end
