class Message < ActiveRecord::Base
	scope :incoming, -> { where(incoming: true) }
	scope :outgoing, -> { where(incoming: false) }

  belongs_to :contact
  belongs_to :user

  def self.conversations
  	Contact.all.collect{|c| c.messages.incoming.last if !c.messages.empty?}
  end
end
