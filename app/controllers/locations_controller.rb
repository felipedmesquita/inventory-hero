class LocationsController < ApplicationController
  def index
    @locations = Location.order(inventory_counts: :desc, code: :asc)
  end

  def show
    @location = Location.find(params[:id])
    @items = @location.inventory_items.includes(:product).order("products.sku", :sequence_number)
    @incoming_transfers = @location.incoming_transfers.includes(:inventory_item, :origin_location).order(created_at: :desc).limit(8)
    @outgoing_transfers = @location.outgoing_transfers.includes(:inventory_item, :destination_location).order(created_at: :desc).limit(8)
  end

  def new
    @location = Location.new(active: true, inventory_counts: true)
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to @location, notice: "Location created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def location_params
    params.expect(location: %i[name code inventory_counts active])
  end
end
