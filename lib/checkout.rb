require_relative 'discount'

class Checkout
  attr_reader :prices, :in_my_basket
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

pricing_rules = Discount.new.pricing_rules
checkout = Checkout.new(pricing_rules)

5.times { checkout.scan(:pineapple) }
checkout.total
