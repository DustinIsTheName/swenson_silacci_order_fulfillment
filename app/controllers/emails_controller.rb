class EmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :receive_order_created

  def index

  	@webhooks = Webhook.all

  end

	def receive_order_created

		head :ok, content_type: "text/html"
	
		webhook = Webhook.new(:hook_id => params[:id], :body => params)

		if webhook.save!

			MercuryOrderMailer.send_order(webhook.body).deliver

		end

	end 

end