require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "gets index" do
    get products_url

    assert_response :success
  end

  test "gets show" do
    get product_url(products(:one))

    assert_response :success
  end

  test "gets new" do
    get new_product_url

    assert_response :success
  end

  test "creates product" do
    assert_difference "Product.count", 1 do
      post products_url, params: {
        product: {
          sku: "ABC-003",
          name: "New product",
          description: "Created from test",
          requires_gtin: "0",
          requires_expiration_date: "0",
          active: "1"
        }
      }
    end

    assert_redirected_to product_url(Product.last)
  end
end
