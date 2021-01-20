class Vendor
  attr_reader :name,
              :inventory

  def initialize(name)
    @name      = name
    @inventory = {}
  end

  def check_stock(item)
    if inventory[item]
      inventory[item]
    else
      0
    end
  end

  def stock(item, quantity)
    if check_stock(item) == 0
      inventory[item] = quantity
    else
      inventory[item] += quantity
    end
  end

  def sell_item?(item_name)
    inventory.keys.any? do |item|
      item.name == item_name
    end
  end

  def potential_revenue
    inventory.keys.sum do |item|
      check_stock(item) * item.price
    end 
  end
end
