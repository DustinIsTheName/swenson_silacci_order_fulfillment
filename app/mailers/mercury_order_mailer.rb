class MercuryOrderMailer < ApplicationMailer

	default to: 'dustin@wittycreative.com'

	def send_order(body)

		@body = body

		mail(from: 'no-reply@shopify.com', subject: 'New Online Flowers Order')

	end
	
end
