class TransferBatchesController < ApplicationController
  def new
    @transfer_batch = TransferBatch.new
    @locations = Location.active.order(:code)
  end

  def create
    destination = Location.find(params[:transfer_batch][:destination_location_id])
    barcodes = params[:transfer_batch][:barcodes].to_s.lines.map(&:strip).reject(&:blank?)
    @transfer_batch = TransferBatch.create!(destination_location: destination)
    inventory_items = InventoryItem.where(barcode: barcodes).index_by(&:barcode)

    barcodes.each do |barcode|
      item = inventory_items[barcode]
      @transfer_batch.add_item!(item) if item.present?
    end

    redirect_to @transfer_batch, notice: "Transfer batch created."
  end

  def show
    @transfer_batch = TransferBatch.includes(
      :destination_location,
      transfer_batch_items: [ :origin_location, { inventory_item: :product } ]
    ).find(params[:id])
  end

  def commit
    transfer_batch = TransferBatch.find(params[:id])
    transfer_batch.commit!
    redirect_to transfer_batch, notice: "Transfer batch committed."
  end
end
