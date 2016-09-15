class EmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:receive_order_created, :receive_ajax]

  def index

  	@webhooks = Webhook.all

  	@ajax = AjaxRequest.all

  end

	def receive_order_created

		head :ok, content_type: "text/html"
	
		webhook = Webhook.new(:hook_id => params[:id], :body => params)

		if webhook[:body]["note"]
			unless webhook[:body]["note"].include? 'house_account:'
				if webhook.save!

					MercuryOrderMailer.send_order(webhook.body).deliver

				end
			end
		else
			if webhook.save!

				MercuryOrderMailer.send_order(webhook.body).deliver

			end
		end
	end

	def receive_ajax

		ajax = AjaxRequest.new(:body => params)

		if ajax.save!

			MercuryOrderMailer.send_ajax_order(ajax.body).deliver



		end

	end

end