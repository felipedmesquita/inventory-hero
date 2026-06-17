class InventoryItem < ApplicationRecord
  belongs_to :product
  belongs_to :location
  has_many :transfers, dependent: :restrict_with_exception
  has_many :transfer_batch_items, dependent: :destroy

  enum :status, {
    available: 0,
    reserved: 1,
    picked: 2,
    sold: 3,
    damaged: 4,
    archived: 5
  }, default: :available, validate: true

  before_validation :assign_barcode

  validates :sequence_number,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 },
    uniqueness: { scope: :product_id }
  validates :barcode, presence: true, uniqueness: true

  scope :inventory_counted, -> { joins(:location).merge(Location.inventory_counted) }

  def missing_required_details?
    (product.requires_gtin? && gtin.blank?) ||
      (product.requires_expiration_date? && expiration_date.blank?)
  end

  def move_to!(destination_location, note: nil)
    Transfer.move!(inventory_item: self, destination_location:, note:)
  end

  private

  def assign_barcode
    return if barcode.present? || product.blank? || sequence_number.blank?

    self.barcode = "#{product.sku}-#{sequence_number.to_s.rjust(6, "0")}"
  end
end
