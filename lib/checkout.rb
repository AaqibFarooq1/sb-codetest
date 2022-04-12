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

    basket.inject(Hash.new(0)) { |items, item| items[item] += 1; items }.each do |item, count| # loop over items in the basket
      total += in_my_basket.apply_discount(item, count, total) # accumulate total for the basket
    end
    
    puts "Total: #{total}"
    total
  end

  private

  def basket
    @basket ||= Array.new
  end
end

# example below can be removed or changed if needed
pricing_rules = Discount.new.pricing_rules # get prices
checkout = Checkout.new(pricing_rules) # create instance of Checkout class with prices
5.times { checkout.scan(:pineapple) } # scan items
checkout.total # get basket total
