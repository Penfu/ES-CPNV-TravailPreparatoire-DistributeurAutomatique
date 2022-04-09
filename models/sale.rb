class Sale
    attr_reader :item, :datetime

    def initialize(item, datetime)
        @item = item
        @datetime = DateTime.parse(datetime.to_s)
    end
end