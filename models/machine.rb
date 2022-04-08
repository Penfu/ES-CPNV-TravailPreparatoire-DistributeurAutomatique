class Machine
    require_relative '../exceptions/item_not_found'
    require_relative '../exceptions/item_out_of_stock'
    require_relative '../exceptions/not_enough_money'

    def initialize(items)
        @amount = 0
        @balance = 0
        @items = items
    end

    def insert(amount)
        @amount += amount
    end

    def choose(code)
        item = @items.find { |i| i.code == code }

        raise ItemNotFound.new "Invalid selection!"                    if item.nil?
        raise ItemOutOfStock.new "Item #{item.name}: Out ofstock!"     if item.quantity == 0
        raise NotEnoughMoney.new "Not enough money!"                   if item.price > @amount
        
        @amount -= item.price
        @balance += item.price
        item.quantity -= 1

        return "Vending #{item.name}"
    end

    def get_change
        @amount.round(2)
    end

    def get_balance
        @balance.round(2)
    end
end