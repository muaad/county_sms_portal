class Contact < ActiveRecord::Base
	scope :favorites, -> { where(favorite: true) }
	has_many :messages

	def profile_incomplete?
		name.nil? || location.nil?
	end
end
