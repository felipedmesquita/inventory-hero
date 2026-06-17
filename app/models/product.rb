class Product < ApplicationRecord
  has_many :inventory_items, dependent: :destroy

  before_validation :normalize_sku

  validates :sku, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  scope :active, -> { where(active: true) }

  private

  def normalize_sku
    self.sku = sku.to_s.strip.upcase.presence
  end
end
