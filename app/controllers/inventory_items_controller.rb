class InventoryItemsController < ApplicationController
  def index
    @query = params[:query].to_s.strip
    @inventory_items = InventoryItem.includes(:product, :location).order(created_at: :desc)
    if @query.present?
      @inventory_items = @inventory_items.joins(:product).where(
        "inventory_items.barcode ILIKE :query OR products.sku ILIKE :query OR products.name ILIKE :query",
        query: "%#{@query}%"
      )
    end
  end

  def show
    @inventory_item = InventoryItem.find(params[:id])
    @locations = Location.active.where.not(id: @inventory_item.location_id).order(:code)
    @transfers = @inventory_item.transfers.includes(:origin_location, :destination_location).order(created_at: :desc)
  end

  def new
    @inventory_item = InventoryItem.new(status: :available)
    set_form_collections
  end

  def create
    @inventory_item = InventoryItem.new(inventory_item_params)
    if @inventory_item.save
      redirect_to @inventory_item, notice: "Inventory item created."
    else
      set_form_collections
      render :new, status: :unprocessable_entity
    end
  end

  def move
    @inventory_item = InventoryItem.find(params[:id])
    destination = Location.find(params[:destination_location_id])
    @inventory_item.move_to!(destination, note: params[:note].presence)
    redirect_to @inventory_item, notice: "Inventory item moved."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to @inventory_item, alert: error.record.errors.full_messages.to_sentence
  end

  private

  def set_form_collections
    @products = Product.active.order(:sku)
    @locations = Location.active.order(:code)
  end

  def inventory_item_params
    params.expect(inventory_item: %i[product_id location_id gtin expiration_date status])
  end
end
