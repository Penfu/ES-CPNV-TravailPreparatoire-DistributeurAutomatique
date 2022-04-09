class Item
    attr_reader :name, :code, :price
    attr_accessor :quantity
    
    def initialize(name, code, quantity, price)
        @name = name
        @code = code
        @quantity = quantity
        @price = price
    end
end