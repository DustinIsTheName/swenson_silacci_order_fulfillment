module ApplicationHelper

	def mercury_formatted(order_body)

		$misc_prods = []

		for line in order_body['line_items']
			if line['properties']
				$main_product = line
				$main_product['properties_object'] = {}

				for p in line['properties']
					
					$main_product['properties_object'][p['name']] = p['value']

				end
			elsif line['title'][0..13] == 'Service Charge'
				$service_product = line
			else
				$misc_prods.push(line)
			end
		end

		if order_body['billing_address']['phone']

			bill_phone_area = order_body['billing_address']['phone'][0..2]
			bill_phone_extension = ''
			bill_phone_number = order_body['billing_address']['phone']
			bill_phone_prefix = order_body['billing_address']['phone'][4..6]

		else

			bill_phone_area = ''
			bill_phone_extension = ''
			bill_phone_number = ''
			bill_phone_prefix = ''

		end

		if order_body['shipping_address']['phone']

			ship_phone_area = order_body['shipping_address']['phone'][0..2]
			ship_phone_extension = ''
			ship_phone_number = order_body['shipping_address']['phone']
			ship_phone_prefix = order_body['shipping_address']['phone'][4..6]

		else

			ship_phone_area = ''
			ship_phone_extension = ''
			ship_phone_number = ''
			ship_phone_prefix = ''

		end

		service_price = if $service_product then $service_product['price'] else '' end
		delivery_day = $main_product['properties_object']['Delivery Date'].split('/')[1],
		delivery_month = $main_product['properties_object']['Delivery Date'].split('/')[0],
		delivery_year = $main_product['properties_object']['Delivery Date'].split('/')[2],

		order_to_mercury = {
			"Additional Information"=> '',
			"Bill Address1"=> order_body['billing_address']['address1'],
			"Bill Address2"=> order_body['billing_address']['address2'],
			"Bill City"=> order_body['billing_address']['city'],
			"Bill Country"=> order_body['billing_address']['country_code'],
			"Bill Fax Area Code"=> '',
			"Bill Fax Number"=> '',
			"Bill Fax Prefix"=> '',
			"Bill Name"=> order_body['billing_address']['name'],
			"Bill Phone Area Code"=> bill_phone_area,
			"Bill Phone Extension"=> bill_phone_extension,
			"Bill Phone Number"=> bill_phone_number,
			"Bill Phone Prefix"=> bill_phone_prefix,
			"Bill Phone2 Area Code"=> '',
			"Bill Phone2 Extension"=> '',
			"Bill Phone2 Number"=> '',
			"Bill Phone2 Prefix"=> '',
			"Bill State"=> order_body['billing_address']['province_code'],
			"Bill Zip Code"=> order_body['billing_address']['zip'],
			"Card Message"=> $main_product['properties_object']['Card Message'],
			"CC Cardholder"=> '',
			"CC Company"=> order_body['payment_details']['credit_card_company'],
			"CC CVV Code"=> '',
			"CC Expiration (Month)"=> '',
			"CC Expiration (Year)"=> '',
			"CC Number"=> order_body['payment_details']['credit_card_number'],
			"Delivery (Day)"=> delivery_day,
			"Delivery (Month)"=> delivery_month,
			"Delivery (Year)"=> delivery_year,
			"Delivery Charge"=> '',
			"Delivery Instructions"=> $main_product['properties_object']['Delivery Instructions'],
			"Discount Amount"=> order_body['total_discounts'],
			"Email Address"=> order_body['email'],
			"Occasion Code"=> $main_product['properties_object']['Occasion Code'],
			"Product Amount1"=> $main_product['price'],
			"Product Code1"=> $main_product['title'],
			"Product Description1"=> '',
			"Product Qty1"=> 1
		}

		i = 2

		$misc_prods.each do |misc_prod|
			order_to_mercury["Product Amount"+i.to_s] = misc_prod['price']
			order_to_mercury["Product Code"+i.to_s] = misc_prod['sku']
			order_to_mercury["Product Description"+i.to_s] = misc_prod['title']
			order_to_mercury["Product Qty"+i.to_s] = misc_prod['quantity']

			i += 1
		end

		order_to_mercury["Recipient Address1"] = order_body['shipping_address']['address1']
		order_to_mercury["Recipient Address2"] = order_body['shipping_address']['address2']
		order_to_mercury["Recipient City"] = order_body['shipping_address']['city']
		order_to_mercury["Recipient Company"] = order_body['shipping_address']['company']
		order_to_mercury["Recipient Country Code"] = order_body['shipping_address']['country_code']
		order_to_mercury["Recipient Name"] = order_body['shipping_address']['name']
		order_to_mercury["Recipient Phone Area Code"] = ship_phone_area
		order_to_mercury["Recipient Phone Extension"] = ship_phone_extension
		order_to_mercury["Recipient Phone Number"] = ship_phone_number
		order_to_mercury["Recipient Phone Prefix"] = ship_phone_prefix
		order_to_mercury["Recipient State"] = order_body['shipping_address']['province_code']
		order_to_mercury["Recipient Zip Code"] = order_body['shipping_address']['zip']
		order_to_mercury["Relay Charge"] = ''
		order_to_mercury["Retrans Charge"] = ''
		order_to_mercury["Service Charge"] = service_price
		order_to_mercury["Tax Amount"] = order_body['total_tax']
		order_to_mercury["Total Order Amount"] = order_body['total_price']

		order_to_mercury

	end

end
