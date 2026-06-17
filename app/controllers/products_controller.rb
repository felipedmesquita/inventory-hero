class ProductsController < ApplicationController
  def index
    @products = Product.order(:sku)
  end

  def show
    @product = Product.find(params[:id])
    @items_by_location = @product.inventory_items.includes(:location).group_by(&:location)
  end

  def new
    @product = Product.new(active: true)
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.expect(product: %i[sku name description requires_gtin requires_expiration_date active])
  end
end
