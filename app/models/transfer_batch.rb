class TransferBatch < ApplicationRecord
  belongs_to :destination_location, class_name: "Location", inverse_of: :transfer_batches
  has_many :transfer_batch_items, dependent: :destroy
  has_many :inventory_items, through: :transfer_batch_items

  enum :status, {
    draft: 0,
    committed: 1,
    cancelled: 2
  }, default: :draft, prefix: true, validate: true

  validates :committed_at, presence: true, if: :status_committed?

  def add_item!(inventory_item)
    transfer_batch_items.find_or_create_by!(inventory_item:) do |batch_item|
      batch_item.origin_location = inventory_item.location
    end
  end

  def commit!
    return false unless status_draft?

    transaction do
      transfer_batch_items.includes(:inventory_item).find_each do |batch_item|
        Transfer.move!(
          inventory_item: batch_item.inventory_item,
          destination_location:,
          note: "Transfer batch ##{id}"
        )
      end

      update!(status: :committed, committed_at: Time.current)
    end
  end
end
