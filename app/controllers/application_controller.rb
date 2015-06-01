class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :time_formatter

  def time_formatter time
  	"#{time.strftime("%d/%m/%Y")} #{time.strftime("%I:%M%p")}"  	
  end
end
