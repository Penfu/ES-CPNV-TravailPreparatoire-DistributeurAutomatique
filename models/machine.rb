class Machine
    require 'date'
    
    require_relative '../exceptions/item_not_found'
    require_relative '../exceptions/item_out_of_stock'
    require_relative '../exceptions/not_enough_money'

    attr_reader :change, :balance
    attr_writer :datetime

    def initialize(items)
        @change = 0
        @balance = 0
        @items = items
        @sales = []
    end

    def insert(amount)
        @change += amount
    end

    def choose(code)
        item = @items.find { |i| i.code == code }

        raise ItemNotFound.new "Invalid selection!"                    if item.nil?
        raise ItemOutOfStock.new "Item #{item.name}: Out ofstock!"     if item.quantity == 0
        raise NotEnoughMoney.new "Not enough money!"                   if item.price > @change
        
        @sales << Sale.new(item, !@datetime ? Time.now : @datetime)
        @change -= item.price
        @balance += item.price
        item.quantity -= 1

        return "Vending #{item.name}"
    end

    def change
        @change.round(2)
    end

    def best_sales
        @sales
        .group_by { |sale| sale.datetime.hour }
        .map {|hour, sales| {hour: hour, amount: sales.sum { |sale| sale.item.price }} }
        .sort_by { |hour, amount| amount }.last(3)
    end
end