require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require 'date'
require './lib/item'
require './lib/vendor'
require './lib/market'

class MarketTest < Minitest::Test
  def test_it_exists
    market = Market.new("South Pearl Street Farmers Market")

    assert_instance_of Market, market
  end

  def test_it_has_attributes
    market = Market.new("South Pearl Street Farmers Market")

    assert_equal "South Pearl Street Farmers Market", market.name
    assert_equal [], market.vendors
  end

  def test_it_can_add_vendors
    market  = Market.new("South Pearl Street Farmers Market")
    vendor1 = Vendor.new("Rocky Mountain Fresh")
    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor3 = Vendor.new("Palisade Peach Shack")

    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)

    assert_equal [vendor1, vendor2, vendor3], market.vendors
  end

  def test_it_can_list_vendor_names
    market  = Market.new("South Pearl Street Farmers Market")
    vendor1 = Vendor.new("Rocky Mountain Fresh")
    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor3 = Vendor.new("Palisade Peach Shack")

    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)

    expected = ["Rocky Mountain Fresh",
                "Ba-Nom-a-Nom",
                "Palisade Peach Shack"]

    assert_equal expected, market.vendor_names
  end

  def test_list_vendors_that_sell_item
    market  = Market.new("South Pearl Street Farmers Market")
    vendor1 = Vendor.new("Rocky Mountain Fresh")

    item1 = Item.new({name: 'Peach', price: "$0.75"})
    item2 = Item.new({name: 'Tomato', price: "$0.50"})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)

    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)

    vendor3 = Vendor.new("Palisade Peach Shack")
    vendor3.stock(item1, 65)

    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)

    assert_equal [vendor1, vendor3], market.vendors_that_sell('Peach')
    assert_equal [vendor2], market.vendors_that_sell("Banana Nice Cream")
  end

  def test_total_inventory
    market = Market.new("South Pearl Street Farmers Market")

    item1 = Item.new({name: "Peach", price: "$0.75"})
    item2 = Item.new({name: "Tomato", price: "$0.50"})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    vendor1 = Vendor.new("Rocky Mountain Fresh")
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)

    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)

    vendor3 = Vendor.new("Palisade Peach Shack")
    vendor3.stock(item1, 65)
    vendor3.stock(item3, 10)

    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)

    expected = {
                item1 => {
                          quantity: 100,
                          vendors:  [vendor1, vendor3]
                },
                item2 => {
                          quantity: 7,
                          vendors:  [vendor1]
                },
                item4 => {
                          quantity: 50,
                          vendors:  [vendor2]
                },
                item3 => {
                          quantity: 35,
                          vendors:  [vendor2, vendor3]
                }
               }

    assert_equal expected, market.total_inventory
  end

  def test_list_sorted_items
    market = Market.new("South Pearl Street Farmers Market")

    item1 = Item.new({name: "Peach", price: "$0.75"})
    item2 = Item.new({name: "Tomato", price: "$0.50"})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    vendor1 = Vendor.new("Rocky Mountain Fresh")
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)

    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)

    vendor3 = Vendor.new("Palisade Peach Shack")
    vendor3.stock(item1, 65)
    vendor3.stock(item3, 10)

    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)

    expected = ["Banana Nice Cream",
                "Peach",
                "Peach-Raspberry Nice Cream",
                "Tomato"]

    assert_equal expected, market.sorted_item_list
  end

  def test_list_overstocked_items
    market = Market.new("South Pearl Street Farmers Market")

    item1 = Item.new({name: "Peach", price: "$0.75"})
    item2 = Item.new({name: "Tomato", price: "$0.50"})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    vendor1 = Vendor.new("Rocky Mountain Fresh")
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)

    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor2.stock(item4, 100)
    vendor2.stock(item3, 25)

    vendor3 = Vendor.new("Palisade Peach Shack")
    vendor3.stock(item1, 65)
    vendor3.stock(item3, 10)

    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)

    assert_equal [item1], market.overstocked_items
  end

  def test_it_can_be_created_with_a_date
    market = mock("South Pearl Street Farmers Market")
    market.stubs(:date).returns("24/02/2020")

    assert_equal "24/02/2020", market.date
  end
end
