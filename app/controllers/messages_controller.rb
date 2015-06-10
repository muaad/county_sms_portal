require "sms"
class MessagesController < ApplicationController
  include ActionController::Live
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all#incoming.order(created_at: :desc)
    @conversations = Message.conversations.reverse#.sort_by(&:created_at)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    # @message = Message.new(message_params)

    # respond_to do |format|
    #   if @message.save
    #     format.html { redirect_to @message, notice: 'Message was successfully created.' }
    #     format.json { render :show, status: :created, location: @message }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @message.errors, status: :unprocessable_entity }
    #   end
    # end
    begin
      text = params["Text"]

      if text.downcase.start_with?("county")
        phone_number = params["MobileNumber"]
        contact = Contact.find_or_create_by! phone_number: phone_number
        msg = text.split(" ")[1..text.length].join(" ")
        Message.create! contact: contact, user: current_user, text: msg

        if msg.downcase.include?("name:") && msg.downcase.include?("location:")
          name = msg.split(",")[0].split(":")[1].strip
          location = msg.split(",")[1].split(":")[1].strip
          contact.update(name: name, location: location)
        end
        if contact.profile_incomplete?
          puts ">>>>>>>> Anything here?"
          SMS.send_message("Hi. We don't seem to have your details. Please reply with your details in this format: Name: John, Location: Upperhill. Substitute with your real name and location. Don't forget to start with the word 'County' Thanks.", phone_number)
        end
      end
      render json: {success: true}
    rescue => error      
      respond_to do |format|
        format.all { render json: {error: error, status: :unprocessable_entity} }
      end
    end
  end

  # def receipts
  #   if params.has_key? (:receipts)
  #     if params[:receipts][:receipt].kind_of? Array
  #       params[:receipts][:receipt].each do |receipt|
  #         receipt_id = receipt[:reference]
  #         delivered = receipt[:status]
  #         time_of_delivery = receipt[:timestamp]
  #         sms = Sms.find_by_receipt_id receipt_id
  #         if !sms.nil?
  #           sms.delivered = delivered == "D"
  #           sms.time_of_delivery = time_of_delivery
  #           sms.save!
  #         end
  #       end
  #     else
  #       if params[:receipts][:receipt].any?
  #         receipt = params[:receipts][:receipt]
  #         receipt_id = receipt[:reference]
  #         delivered = receipt[:status]
  #         time_of_delivery = receipt[:timestamp]
  #         sms = Sms.find_by_receipt_id receipt_id
  #         if !sms.nil?
  #           sms.delivered = delivered == "D"
  #           sms.time_of_delivery = time_of_delivery
  #           sms.save!
  #         end
  #       end
  #     end
  #   end
  #   render text: "OK"
  # end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def conversation
    contact = Contact.find(params[:contact_id])
    @messages = contact.messages
    @message = @messages.last
    @messages.update_all(read: true)

    # respond_to do |format|
    #   format.html { render :conversation }
    #   format.json { render json: { conversation: @messages }}
    # end
  end

  def outgoing
    sms = SMS.new
    sms.send_message params[:message], params[:phone_number]
    render json: {success: true}
  end

  def events
    response.headers["Content-Type"] = "text/event-stream"
    start = Time.zone.now
    10.times do |n|
      Message.uncached do
        Message.where('created_at > ?', start).each do |message|
          response.stream.write "data: #{message.to_json}\n\n"
          start = message.created_at
        end
      end
      sleep 2
    end
  rescue IOError
    logger.info "Stream closed"
  ensure
    response.stream.close
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:text, :contact_id, :incoming, :user_id)
    end
end
