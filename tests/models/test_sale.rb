require 'minitest/autorun'

require_relative '../../models/item'
require_relative '../../models/sale'
require_relative '../../models/machine'

class TestSale < MiniTest::Test
  def setup
    @machine = Machine.new([
      Item.new("Smarlies", "A01", 100, 1.60), 
      Item.new("Carampar", "A02", 50, 0.60), 
      Item.new("Avril", "A03", 20, 2.10), 
      Item.new("KokoKola", "A04", 10, 2.95) 
    ])
  end

  def test_item_sales_timestamp_and_best_sales_group_by_hour
    money = 1000.00
    item = "A01"
    datetimes = [ 
        "2020-01-01T20:30:00",
        "2020-03-01T23:30:00",
        "2020-03-04T09:22:00",
        "2020-04-01T23:00:00",
        "2020-04-01T23:59:59",
        "2020-04-04T09:12:00"
    ]

    excpected_sales = [
        "Hour 23 generated a revenue of 4.80",
        "Hour 9 generated a revenue of 3.20",
        "Hour 20 generated a revenue of 1.60"
    ]

    @machine.insert(money)
    datetimes.each do |datetime|
        @machine.datetime = datetime
        @machine.choose(item)
    end

    best_sales = @machine.best_sales
    best_sales.each_with_index do |sale, i|
        assert_equal(excpected_sales[i], "Hour #{sale[:hour]} generated a revenue of #{"%.2f" % [sale[:amount]]}")
    end
  end
end

    