class Message < ActiveRecord::Base
	scope :incoming, -> { where(incoming: true) }
	scope :outgoing, -> { where(incoming: false) }
	
  belongs_to :contact
  belongs_to :user
end
