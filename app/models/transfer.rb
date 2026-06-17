class Transfer < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :origin_location, class_name: "Location", inverse_of: :outgoing_transfers
  belongs_to :destination_location, class_name: "Location", inverse_of: :incoming_transfers

  validates :destination_location, comparison: { other_than: :origin_location }
  validate :origin_location_matches_item_location, on: :create

  def self.move!(inventory_item:, destination_location:, note: nil)
    transaction do
      inventory_item.with_lock do
        create!(
          inventory_item:,
          origin_location: inventory_item.location,
          destination_location:,
          note:
        ).tap do
          inventory_item.update!(location: destination_location)
        end
      end
    end
  end

  private

  def origin_location_matches_item_location
    return if inventory_item.blank? || origin_location.blank?
    return if inventory_item.location_id == origin_location_id

    errors.add(:origin_location, "must match the inventory item's current location")
  end
end
