class Item
    attr_accessor :name, :code, :quantity, :price

    def initialize(name, code, quantity, price)
        @name = name
        @code = code
        @quantity = quantity
        @price = price
    end
end