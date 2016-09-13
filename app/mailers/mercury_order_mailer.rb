class MercuryOrderMailer < ApplicationMailer
	add_template_helper(AnnotationsHelper)

	default to: 'dustin@wittycreative.com'

	def send_order(body)

		@body = body

		mail(from: 'no-reply@shopify.com', subject: 'CMG Test Order') do |format|
			format.text
		end

	end

end
