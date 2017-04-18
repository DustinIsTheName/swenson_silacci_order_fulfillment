module ApplicationHelper

	def mercury_formatted(order_body)

		$misc_prods = []
		attributes = {}

		for attri in order_body['note_attributes']
			attributes[attri["name"]] = attri["value"]
		end

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

		if order_body['billing_address']
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
		end

		if order_body['shipping_address']
			if order_body['shipping_address']['phone']

				ship_phone_area = ''
				ship_phone_extension = ''
				ship_phone_number = order_body['shipping_address']['phone']
				ship_phone_prefix = ''

			else

				ship_phone_area = ''
				ship_phone_extension = ''
				ship_phone_number = ''
				ship_phone_prefix = ''

			end
		end

		service_price = if $service_product then $service_product['price'] else '' end
		delivery_day = attributes['Delivery Date'].split('/')[1]
		delivery_month = attributes['Delivery Date'].split('/')[0]
		delivery_year = attributes['Delivery Date'].split('/')[2]

		order_to_mercury = {
			"Additional Information"=> '',
			"Bill Address1"=> order_body['billing_address']['address1']&.strip,
			"Bill Address2"=> order_body['billing_address']['address2']&.strip,
			"Bill City"=> order_body['billing_address']['city']&.strip,
			"Bill Country"=> order_body['billing_address']['country_code'],
			"Bill Fax Area Code"=> '',
			"Bill Fax Number"=> '',
			"Bill Fax Prefix"=> '',
			"Bill Name"=> order_body['billing_address']['name']&.strip,
			"Bill Phone Area Code"=> '',
			"Bill Phone Extension"=> '',
			"Bill Phone Number"=> bill_phone_number,
			"Bill Phone Prefix"=> '',
			"Bill Phone2 Area Code"=> '',
			"Bill Phone2 Extension"=> '',
			"Bill Phone2 Number"=> '',
			"Bill Phone2 Prefix"=> '',
			"Bill State"=> order_body['billing_address']['province_code'],
			"Bill Zip Code"=> order_body['billing_address']['zip'],
			"Card Message"=> attributes['Card Message']&.strip,
			"CC Cardholder"=> '',
			"CC CVV Code"=> '',
			"CC Expiration (Month)"=> '',
			"CC Expiration (Year)"=> '',
			"Delivery (Day)"=> delivery_day,
			"Delivery (Month)"=> delivery_month,
			"Delivery (Year)"=> delivery_year,
			"Delivery Charge"=> '',
			"Delivery Instructions"=> attributes['Delivery Instructions']&.strip,
			"Discount Amount"=> order_body['total_discounts'],
			"E-mail Address"=> order_body['email']&.strip,
			"Occasion Code"=> attributes['Occasion Code'],
			"Product Amount1"=> $main_product['price'],
			"Product Code1"=> $main_product['sku'],
			"Product Description1"=> $main_product['title'],
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

		if order_body['payment_details']
			order_to_mercury["CC Company"] = order_body['payment_details']['credit_card_company']
			order_to_mercury["CC Number"] = order_body['payment_details']['credit_card_number']
		else
			order_to_mercury["CC Company"] = 'Paypal'
			order_to_mercury["CC Number"] = ''
		end

		order_to_mercury["Recipient Address1"] = order_body['shipping_address']['address1']&.strip
		order_to_mercury["Recipient Address2"] = order_body['shipping_address']['address2']&.strip
		order_to_mercury["Recipient City"] = order_body['shipping_address']['city']&.strip
		order_to_mercury["Recipient Company"] = order_body['shipping_address']['company']&.strip
		order_to_mercury["Recipient Country Code"] = order_body['shipping_address']['country_code']
		order_to_mercury["Recipient Name"] = order_body['shipping_address']['name']&.strip
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

		Hash[order_to_mercury.sort]

	end

	def ajax_mercury_formatted(order_from_ajax, send_order)

		prop = order_from_ajax['attributes']

		delivery_day = prop['Delivery Date'].split('/')[1]
		delivery_month = prop['Delivery Date'].split('/')[0]
		delivery_year = prop['Delivery Date'].split('/')[2]

		order_to_mercury = {
			"Additional Information"=> '',
			"Bill Address1"=> prop['Bill Address']&.strip,
			"Bill Address2"=> '',
			"Bill City"=> '',
			"Bill Country"=> '',
			"Bill Fax Area Code"=> '',
			"Bill Fax Number"=> '',
			"Bill Fax Prefix"=> '',
			"Bill Name"=> '',
			"Bill Phone Area Code"=> '',
			"Bill Phone Extension"=> '',
			"Bill Phone Number"=> prop['Bill Phone']&.strip,
			"Bill Phone Prefix"=> '',
			"Bill Phone2 Area Code"=> '',
			"Bill Phone2 Extension"=> '',
			"Bill Phone2 Number"=> '',
			"Bill Phone2 Prefix"=> '',
			"Bill State"=> '',
			"Bill Zip Code"=> '',
			"Card Message"=> prop['Card Message']&.strip,
			"CC Cardholder"=> prop['House Account'],
			"CC Company"=> 'INHOUSE',
			"CC CVV Code"=> '',
			"CC Expiration (Month)"=> '',
			"CC Expiration (Year)"=> '',
			"CC Number"=> '',
			"Delivery (Day)"=> delivery_day,
			"Delivery (Month)"=> delivery_month,
			"Delivery (Year)"=> delivery_year,
			"Delivery Charge"=> '',
			"Delivery Instructions"=> prop['Delivery Instructions']&.strip,
			"Discount Amount"=> '',
			"E-mail Address"=> prop['Bill Email']&.strip,
			"Occasion Code"=> prop['Occasion Code'],
			"Product Amount1"=> prop['Product1 Amount'],
			"Product Code1"=> prop['Product1 Sku'],
			"Product Description1"=> prop['Product1 Name'],
			"Product Qty1"=> 1,
			"Product Amount2"=> sprintf('%.2f', prop['Product2 Amount']),
			"Product Code2"=> prop['Product2 Sku'],
			"Product Description2"=> prop['Product2 Name'],
			"Product Qty2"=> prop['bears_qty'],
			"Product Amount3"=> sprintf('%.2f', prop['Product3 Amount']),
			"Product Code3"=> prop['Product3 Sku'],
			"Product Description3"=> prop['Product3 Name'],
			"Product Qty3"=> prop['balloons_qty'],
			"Product Amount4"=> prop['Product4 Amount'],
			"Product Code4"=> prop['Product4 Sku'],
			"Product Description4"=> prop['Product4 Name'],
			"Product Qty4"=> prop['chocolates_qty'],
			"Recipient Address1"=> prop['Ship Address1'],
			"Recipient Address2"=> '',
			"Recipient City"=> prop['Ship City']&.strip,
			"Recipient Company"=> prop['Ship Company']&.strip,
			"Recipient Country Code"=> prop['ShipCountry']&.strip,
			"Recipient Name"=> prop['Ship Name']&.strip,
			"Recipient Phone Area Code"=> '',
			"Recipient Phone Extension"=> prop['Ship Phone2 Ext'],
			"Recipient Phone Number"=> prop['Ship Phone'].gsub('-', '').gsub('.', ''),
			"Recipient Phone Prefix"=> '',
			"Recipient State"=> prop['Ship State'],
			"Recipient Zip Code"=> prop['Ship Zip Code'],
			"Relay Charge"=> '',
			"Retrans Charge"=> '',
			"Service Charge"=> prop['Service Charge'],
			"Tax Amount"=> prop['Tax Amount'],
			"Total Order Amount"=> prop['Total Order Amount']
		}

		create_order(order_to_mercury, order_from_ajax, prop) if send_order

		order_to_mercury

	end

	def create_order(new_order, ajax_info, prop)

		shopify_shop='swenson-and-silacci-flowers.myshopify.com'
		shopify_api_key='4cc4f2b265e47caddfbf4fdab6c66b48'
		shopify_password='a6bff4ed6538965649c18c70bfe0f39f'

		if prop['House Account']
			house_account = prop['House Account']
		else
			house_account = ''
		end

		ShopifyAPI::Base.site = "https://#{shopify_api_key}:#{shopify_password}@#{shopify_shop}/admin"

		qued_order = {
		  order: {
		    line_items: [
		    	{	
		    		quantity: 1,
		    		variant_id: ajax_info["id"],
		    		properties: [
	    				{"name"=>"Delivery Date", "value"=> prop['Delivery Date']},
	    				# {"name"=>"Location Type", "value"=> prop['Location Type']},
	    				# {"name"=>"Occasion Code", "value"=> prop['Occasion Code']},
	    				{"name"=>"Card Message", "value"=> prop['Card Message']}
		    		]
	    		}
		    ],
		    shipping_address: {
		    	address1: new_order['Recipient Address1'],
		    	city: new_order['Recipient City'],
		    	country: new_order['Recipient Country Code'],
		    	phone: new_order['Recipient Phone Number'],
		    	zip: new_order['Recipient Zip Code'],
		    	name: new_order['Recipient Name'],
		    	province: new_order['Recipient State']
		    },
		    email: new_order['E-mail Address'],
		    note: 'house_account:' + house_account,
		    note_attributes: [
					{"name"=>"Delivery Date", "value"=> prop['Delivery Date']},
					# {"name"=>"Location Type", "value"=> prop['Location Type']},
					# {"name"=>"Occasion Code", "value"=> prop['Occasion Code']},
					{"name"=>"Card Message", "value"=> prop['Card Message']}
		    ],
		    tax_line: [
          {
            price: prop['Tax Amount']
          }
        ]
		  }
		}

		qued_order[:order][:line_items] << { variant_id: ajax_info["bear_id"], quantity: new_order['Product Qty2'] } if new_order['Product Qty2']
		qued_order[:order][:line_items] << { variant_id: ajax_info["balloon_id"], quantity: new_order['Product Qty3'] } if new_order['Product Qty3']
		qued_order[:order][:line_items] << { variant_id: ajax_info["chocolate_id"], quantity: new_order['Product Qty4'] } if new_order['Product Qty4']
		qued_order[:order][:line_items] << { variant_id: ajax_info["service_id"], quantity: 1 } if new_order['service_id'] != ''

		puts qued_order

		puts ajax_info

		shopify_order = ShopifyAPI::Order.new(qued_order)

		shopify_order.save

	end

end
