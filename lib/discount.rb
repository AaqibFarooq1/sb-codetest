class Discount

	attr_reader :item, :count

	def apply_discount(item, count, total)
		@item = item
		@count = count
		limit = discounts[@item][:discount_limit]
		case discounts[@item][:discount_type]
		when '2-for-1'
			total = two_for_one(total, limit)
		when 'half-price'
			total = half_price_on(total, limit)
		when 'buy-3-get-1-free'
			total = buy_x_get_y_free(total, limit, 3, 1)
		else
			total = pricing_rules[@item] * @count
		end
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

	def discounts
		return {
			apple: {
				discount_type: '2-for-1',
				discount_limit: -1
			},
			orange: {
				discount_type: '',
				discount_limit: 0
			},
			pear: {
				discount_type: '2-for-1',
				discount_limit: -1
			},
			banana: {
				discount_type: 'half-price',
				discount_limit: -1
			},
			pineapple: {
				discount_type: 'half-price',
				discount_limit: 1
			},
			mango: {
				discount_type: 'buy-3-get-1-free',
				discount_limit: -1
			}
		}
	end

	def two_for_one(total, limit)
		# if there's only 1 item, apply normal price
		# the logic for 2-for-1 is the same same as buy_1_get_1_free so we can use the existing function
		total = @count<2 ? pricing_rules[@item] * @count : buy_x_get_y_free(total, limit, 1, 1)
		total
	end

	def half_price_on(total, limit)
		if limit==-1 || @count<=limit # check if limit applies
			total = (pricing_rules[@item] / 2) * @count # apply half price
		elsif @count > limit # check if quantity means the offer is eligible
			limit.times{ total += (pricing_rules[item] / 2) } # apply half price to the eligible items
			total += (pricing_rules[@item]) * (@count - limit) # apply normal price to the remaining items
		else
			total = pricing_rules[@item] * @count # apply normal price if quantity is below required offer quantity
		end

		total
	end

	def buy_x_get_y_free(total, limit, buy, free)
		discount_factor = 1-(free.to_f/(buy+free).to_f) # calculate discount factor
		times_to_apply = @count>=(buy+free) ? @count/(buy+free) : 0 # calculate how many times to apply offer based on multibuy
		times_to_apply = limit if limit<-1 # override and apply limit to number of times offer is applied
		remainder = @count-(times_to_apply*(buy+free)) # number of remaining items after multibuy
		total = (pricing_rules[@item] * ((buy+free)*times_to_apply) * discount_factor).to_i # apply offer
		total += pricing_rules[@item] * remainder # add price of items outside of this offer
		total
	end
end
