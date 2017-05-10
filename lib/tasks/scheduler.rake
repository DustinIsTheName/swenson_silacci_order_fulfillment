task :check_webhook => :environment do
  Function.checkForWebhook
end