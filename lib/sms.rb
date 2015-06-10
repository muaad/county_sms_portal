require 'AfricasTalkingGateway'
class SMS
	def initialize
    @user = ENV['SMS_GATEWAY_USER']
    @password = ENV['SMS_GATEWAY_PASSWORD']
    @url = ENV['SMS_GATEWAY_URL']
    @shortcode = ENV['SMS_SHORTCODE']
    @campaign_id = ENV['SMS_CAMPAIGN_ID']
    @channel = ENV['SMS_CHANNEL']
  end

  def send to, message
  	`curl -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "username=#{@user}&password=#{@password}&MSISDN=#{to}&content=#{message}&channel=#{@channel}&shortcode=#{@shortcode}&campaignid=#{@campaign_id}&premium=1&multitarget=1" #{@url}`
    # if !Rails.env.production?
    #   `curl -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "username=#{@user}&password=#{@password}&MSISDN=#{to}&content=#{message}&channel=#{@channel}&shortcode=#{@shortcode}&campaignid=#{@campaign_id}&premium=1&multitarget=1" #{@url}`
    # else
    #   puts "<>>>>>> TARGET: INFO\nMSISDN: #{to}\nTEXT: #{message}"
    # end
  end
	# def initialize
	# 	@gateway = AfricasTalkingGateway.new('muaad', ENV['SMS_API_KEY'])
	# end
	def send_message text, phone_number
		send phone_number, text
	# 	begin
	# 	  reports = @gateway.sendMessage(phone_number, text)
		  
	# 	  reports.each {|x|
	# 	    # status is either "Success" or "error message"
	# 	    puts 'number=' + x.number + ';status=' + x.status + ';messageId=' + x.messageId + ';cost=' + x.cost
	# 	  }
	# 	  Message.create! contact: Contact.find_by(phone_number: phone_number), text: text, incoming: false
	# 	rescue AfricasTalkingGatewayException => ex
	# 	  puts 'Encountered an error: ' + ex.message
	# 	end
	end
end