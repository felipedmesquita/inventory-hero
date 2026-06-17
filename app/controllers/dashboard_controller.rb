class DashboardController < ApplicationController
  def index
    @product_count = Product.count
    @item_count = InventoryItem.count
    @counted_item_count = InventoryItem.inventory_counted.count
    @location_count = Location.active.count
    @draft_batches = TransferBatch.status_draft.order(created_at: :desc).limit(5)
    @recent_transfers = Transfer.includes(:inventory_item, :origin_location, :destination_location).order(created_at: :desc).limit(8)
    @locations = Location.order(:code)
  end
end
