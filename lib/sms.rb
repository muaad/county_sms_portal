# require 'AfricasTalkingGateway'
class SMS
	def initialize
    @user = ENV['SMS_GATEWAY_USER']
    @password = ENV['SMS_GATEWAY_PASSWORD']
    @url = ENV['SMS_GATEWAY_URL']
    @shortcode = ENV['SMS_SHORTCODE']
    @campaign_id = ENV['SMS_CAMPAIGN_ID']
    @channel = ENV['SMS_CHANNEL']
  end

  def split_message message
  	message.chars.each_slice(160).map(&:join)
  end

  def send to, message
  	`curl -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "username=#{@user}&password=#{@password}&MSISDN=#{to}&content=#{message}&channel=#{@channel}&shortcode=#{@shortcode}&campaignid=#{@campaign_id}&premium=1&multitarget=1" #{@url}`
  end
	
	def send_message text, phone_number
		segments = [message]
		segments = split_message(message)

		segments.each do |text|
			send phone_number, text
		end
		Message.create! contact: Contact.find_by(phone_number: phone_number), text: text, incoming: false
	end
end