class Contact < ActiveRecord::Base
	has_many :messages

	def profile_incomplete?
		name.nil? || location.nil?
	end
end
