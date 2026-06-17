class Location < ApplicationRecord
  has_many :inventory_items, dependent: :restrict_with_exception
  has_many :outgoing_transfers, class_name: "Transfer", foreign_key: :origin_location_id, dependent: :restrict_with_exception, inverse_of: :origin_location
  has_many :incoming_transfers, class_name: "Transfer", foreign_key: :destination_location_id, dependent: :restrict_with_exception, inverse_of: :destination_location
  has_many :transfer_batches, foreign_key: :destination_location_id, dependent: :restrict_with_exception, inverse_of: :destination_location

  before_validation :normalize_code

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true) }
  scope :inventory_counted, -> { where(inventory_counts: true) }
  scope :not_inventory_counted, -> { where(inventory_counts: false) }

  private

  def normalize_code
    self.code = code.to_s.strip.upcase.presence
  end
end
