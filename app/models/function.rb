class Function < ActiveRecord::Base

	def self.checkForWebhook
		webhooks = ShopifyAPI::Webhook.all
		found_webhook = false
		for webhook in webhooks
			if webhook.address == "https://swenson-silacci.herokuapp.com/order-creation"
				found_webhook = true
			end
		end

		unless found_webhook
			new_webhook = ShopifyAPI::Webhook.create({
				address: "https:\/\/swenson-silacci.herokuapp.com/order-creation",
				topic: "orders\/create",
				format: "json"
			})
			puts new_webhook
		else
			puts "found it"
		end
	end

end