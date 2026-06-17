class TransferBatchItem < ApplicationRecord
  belongs_to :transfer_batch
  belongs_to :inventory_item
  belongs_to :origin_location, class_name: "Location"

  validates :inventory_item_id, uniqueness: { scope: :transfer_batch_id }
  validate :batch_is_draft

  private

  def batch_is_draft
    return if transfer_batch.blank? || transfer_batch.status_draft?

    errors.add(:transfer_batch, "must be draft")
  end
end
