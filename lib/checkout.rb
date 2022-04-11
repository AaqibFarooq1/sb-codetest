require_relative 'discount'

class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices)
    @prices = prices
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = 0
    in_my_basket = Discount.new

    basket.inject(Hash.new(0)) { |items, item| items[item] += 1; items }.each do |item, count|

      total += in_my_basket.apply_discount(item, count, total)

    end

    puts "Total: #{total}"
    total
  end

  private

  def basket
    @basket ||= Array.new
  end
end

checkout = Checkout.new({
  apple: 10,
  orange: 20,
  pear: 15,
  banana: 30,
  pineapple: 100,
  mango: 200
})
5.times { checkout.scan(:pineapple) }
checkout.total