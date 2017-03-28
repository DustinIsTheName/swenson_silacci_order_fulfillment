class MercuryOrderMailer < ApplicationMailer
	add_template_helper(ApplicationHelper)

	default to: 'mercury2@onlineflowersorders.com'
	# default to: 'phil@teamcmg.com'

	def send_order(body)

		@body = body

		mail(from: 'no-reply@shopify.com', subject: 'Swenson Silacci Order') do |format|
			format.text
		end

	end

	def send_ajax_order(body)

		@body = body

		mail(from: 'no-reply@shopify.com', subject: 'Swenson Silacci Order') do |format|
			format.text
		end

	end

end
