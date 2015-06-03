require 'AfricasTalkingGateway'
class SMS
	def initialize
		@gateway = AfricasTalkingGateway.new('muaad', ENV['SMS_API_KEY'])
	end
	def send_message text, phone_number
		begin
		  reports = @gateway.sendMessage(phone_number, text)
		  
		  reports.each {|x|
		    # status is either "Success" or "error message"
		    puts 'number=' + x.number + ';status=' + x.status + ';messageId=' + x.messageId + ';cost=' + x.cost
		  }
		  Message.create! contact: Contact.find_by(phone_number: phone_number), text: text, incoming: false
		rescue AfricasTalkingGatewayException => ex
		  puts 'Encountered an error: ' + ex.message
		end
	end
end