require 'minitest/autorun'

require_relative '../../exceptions/item_not_found'
require_relative '../../exceptions/item_out_of_stock'
require_relative '../../exceptions/not_enough_money'

require_relative '../../models/item'
require_relative '../../models/machine'

class TestMachine < MiniTest::Test
  def setup
    @machine = Machine.new([
      Item.new("Smarlies", "A01", 10, 1.60), 
      Item.new("Carampar", "A02", 5, 0.60), 
      Item.new("Avril", "A03", 2, 2.10), 
      Item.new("KokoKola", "A04", 1, 2.95) 
    ])
  end

    def test_choose_an_item_without_money_raises_exception
      item = "A01"

      assert_raises NotEnoughMoney do @machine.choose(item) end
      assert_equal(0, @machine.get_balance)
    end

    def test_choose_an_item_without_enough_money_raises_exception
      money = 1.00
      item = "A01"
      @machine.insert(money)

      assert_raises NotEnoughMoney do @machine.choose(item) end
      assert_equal(money, @machine.get_change)
    end

    def test_choose_an_item_out_of_stock_raises_exception
      money = 6.00
      item = 'A04'

      excepected_message = "Vending KokoKola"
      excepected_change = 3.05

      @machine.insert(money)

      assert_equal(excepected_message, @machine.choose(item))
      assert_raises ItemOutOfStock do @machine.choose(item) end
      assert_equal(excepected_change, @machine.get_change)
    end

    def test_choose_an_invalid_item_raises_exception
      money = 1.00
      item = 'A05'

      @machine.insert(money)

      assert_raises ItemNotFound do @machine.choose(item) end
      assert_equal(money, @machine.get_change)
    end

    def test_that_change_is_equal_to_inserted_money_minus_selected_article_price
      money = 3.40
      item = "A01"

      excepected_message = "Vending Smarlies"
      excepected_change = 1.80

      @machine.insert(money)

      assert_equal(excepected_message, @machine.choose(item))
      assert_equal(excepected_change, @machine.get_change)
    end

    def test_that_change_is_correct_after_selecting_an_item
      money = 2.10
      item = "A03"

      excepected_message = "Vending Avril"
      excepected_change = 0.00
      excepected_balance = 2.10

      @machine.insert(money)

      assert_equal(excepected_message, @machine.choose(item))
      assert_equal(excepected_change, @machine.get_change)
      assert_equal(excepected_balance, @machine.get_balance)
    end

    def test_that_change_is_correct_after_selecting_multiple_items
      money = 6.00
      items = ["A04", "A04", "A01", "A02", "A02"]

      excepected_messages = [
        "Vending KokoKola",
        "Item KokoKola: Out of stock!",
        "Vending Smarlies",
        "Vending Carampar",
        "Vending Carampar"
      ]
      excepected_change = 6.25
      excepected_balance = 5.75

      @machine.insert(money)
      assert_equal(excepected_messages[0], @machine.choose(items[0]))

      @machine.insert(money)
      assert_raises ItemOutOfStock do @machine.choose(items[1]) end
      assert_equal(excepected_messages[2], @machine.choose(items[2]))
      assert_equal(excepected_messages[3], @machine.choose(items[3]))
      assert_equal(excepected_messages[4], @machine.choose(items[4]))
      assert_equal(excepected_change, @machine.get_change)
      assert_equal(excepected_balance, @machine.get_balance)
    end 
end