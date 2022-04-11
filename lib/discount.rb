class Discount

    attr_reader :item, :count

    def apply_discount(item, count, total)
      offer = true
      case item
      when :apple
        total = two_for_one(item, count, total)
      when :orange
        offer = false
      when :pear
        total = two_for_one(item, count, total)
      when :banana
        total = half_price_on(item, count, total, -1) # -1 means half price on all items
      when :pineapple
        total = half_price_on(item, count, total, 1) # half price on 1 item per cutomer
      when :mango
        total = buy_x_get_y_free(item, count, total, 3, 1)
      else
        offer = false
      end
      (total = pricing_rules[item] * count) unless offer # apply normal price to items without offer
      total
    end

    def pricing_rules
		return {
			apple: 10,
			orange: 20,
			pear: 15,
			banana: 30,
			pineapple: 100,
			mango: 200
		}
	end

    def two_for_one(item, count, total)
        total = buy_x_get_y_free(item, count, total, 1, 1) # the logic for 2-for-1 is the same same as buy_1_get_1_free so we can use the existing function
        total
    end

    def half_price_on(item, count, total, per_customer_limit)
        if per_customer_limit==-1
            total = (pricing_rules[item] / 2) * count # apply half price to all items
        elsif count >= per_customer_limit # check if number of items means the offer is eligible
            per_customer_limit.times{ total += (pricing_rules[item] / 2) } # apply half price to the eligible items
            total += (pricing_rules[item]) * (count - per_customer_limit) # apply normal price to the remaining items
        else
            total = pricing_rules[item] * count # apply normal price if quantity is below required offer quantity
        end
        total
    end

    def buy_x_get_y_free(item, count, total, buy, free)
        discount_factor = 1-(free.to_f/(buy+free).to_f) # calculate discount factor
        times_to_apply = count>=(buy+free) ? count/(buy+free) : 0 # calculate how many times to apply offer based on multibuy
        remainder = count-(times_to_apply*(buy+free)) # number of remaining items after multibuy
        total = pricing_rules[item] * ((buy+free)*times_to_apply) * discount_factor # apply offer
        total += pricing_rules[item] * remainder # add price of items outside of this offer
        total
    end
end
