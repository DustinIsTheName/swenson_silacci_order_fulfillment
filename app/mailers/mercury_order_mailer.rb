class MercuryOrderMailer < ApplicationMailer
	add_template_helper(ApplicationHelper)

	default to: 'dustin@wittycreative.com'

	def send_order(body)

		@body = body

		mail(from: 'no-reply@shopify.com', subject: 'CMG Test Order') do |format|
			format.text
		end

	end

	def send_ajax_order(body)

		@body = body

		mail(from: 'no-reply@shopify.com', subject: 'CMG Test Order') do |format|
			format.text
		end

	end

end
