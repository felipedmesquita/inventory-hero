require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "gets dashboard" do
    get root_url

    assert_response :success
    assert_select "h1", "Dashboard"
  end
end
