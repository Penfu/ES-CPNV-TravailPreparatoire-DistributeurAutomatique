class Sale
    attr_accessor :item, :datetime

    def initialize(item, datetime)
        @item = item
        @datetime = DateTime.parse(datetime.to_s)
    end
end