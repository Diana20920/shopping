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
end
