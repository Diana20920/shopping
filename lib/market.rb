class Market
  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @name    = name
    @vendors = []
    @date    = Date.today.to_s
  end

  def add_vendor(vendor)
    vendors << vendor
  end

  def vendor_names
    vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item_name)
    vendors.find_all do |vendor|
      vendor.sell_item?(item_name)
    end
  end

  def total_inventory
    total_inventory = {}

    vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        if total_inventory[item].nil?
          total_inventory[item] = {quantity: 0, vendors: []}
        end
        total_inventory[item][:quantity] += quantity
        total_inventory[item][:vendors] << vendor
      end
    end
    total_inventory
  end

  def sorted_item_list
    items = vendors.map do |vendor|
      vendor.inventory.keys
    end.flatten.uniq
    items.map do |item|
      item.name
    end.sort
  end

  def overstocked_items
    overstocked = total_inventory.flat_map do |item, details|
      if details[:quantity] > 50 &&
      details[:vendors].count > 1
          item
      end
    end
    overstocked.compact
  end
end
