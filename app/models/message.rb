class Message < ActiveRecord::Base
	scope :incoming, -> { where(incoming: true) }
	scope :outgoing, -> { where(incoming: false) }
	scope :unread, -> { where(read: false) }

  belongs_to :contact
  belongs_to :user

  def self.conversations
  	Contact.all.collect{|c| c.messages.incoming.last if !c.messages.empty?}.compact
  end

  def sender
  	from = nil
  	if incoming
  		from = contact.name
  	else
  		from = "Nairobi"
  	end
  end
end
