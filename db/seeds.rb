receiving = Location.find_or_create_by!(code: "RCV") do |location|
  location.name = "Receiving"
  location.inventory_counts = false
  location.active = true
end

shelf_a1 = Location.find_or_create_by!(code: "A1") do |location|
  location.name = "Shelf A1"
  location.inventory_counts = true
  location.active = true
end

shelf_b2 = Location.find_or_create_by!(code: "B2") do |location|
  location.name = "Shelf B2"
  location.inventory_counts = true
  location.active = true
end

sold = Location.find_or_create_by!(code: "SOLD") do |location|
  location.name = "Sold"
  location.inventory_counts = false
  location.active = true
end

keyboard = Product.find_or_create_by!(sku: "KEY-001") do |product|
  product.name = "Mechanical keyboard"
  product.description = "Compact keyboard with serialized stock units."
  product.requires_gtin = true
  product.requires_expiration_date = false
  product.active = true
end

coffee = Product.find_or_create_by!(sku: "COF-250") do |product|
  product.name = "Coffee beans 250g"
  product.description = "Perishable retail unit."
  product.requires_gtin = true
  product.requires_expiration_date = true
  product.active = true
end

cable = Product.find_or_create_by!(sku: "USB-C-2M") do |product|
  product.name = "USB-C cable 2m"
  product.description = "Accessory cable."
  product.requires_gtin = false
  product.requires_expiration_date = false
  product.active = true
end

items = [
  { product: keyboard, location: shelf_a1, sequence_number: 1, gtin: "7891000000011" },
  { product: keyboard, location: receiving, sequence_number: 2, gtin: "7891000000011" },
  { product: coffee, location: shelf_b2, sequence_number: 1, gtin: "7891000002501", expiration_date: 3.months.from_now.to_date },
  { product: coffee, location: receiving, sequence_number: 2 },
  { product: cable, location: shelf_a1, sequence_number: 1 },
  { product: cable, location: sold, sequence_number: 2, status: :sold }
]

items.each do |attributes|
  InventoryItem.find_or_create_by!(product: attributes[:product], sequence_number: attributes[:sequence_number]) do |item|
    item.location = attributes[:location]
    item.gtin = attributes[:gtin]
    item.expiration_date = attributes[:expiration_date]
    item.status = attributes[:status] || :available
  end
end

item = InventoryItem.find_by!(product: keyboard, sequence_number: 2)
item.move_to!(shelf_a1, note: "Initial put away") if item.location == receiving
