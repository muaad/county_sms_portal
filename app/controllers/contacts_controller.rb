class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_page
    @contact = Contact.new
  end

  def delete_multiple
    deleted = 0
    params[:delete_contacts].split(',').each do |id|
      Contact.find_by(id: id).destroy
      deleted = deleted + 1
    end
    redirect_to contacts_path, notice: "You have deleted #{deleted} contacts."
  end

  def bulk_upload
    file = params[:contact][:upload_file]
    is_xlsx = File.extname(file.original_filename) == ".xlsx"
    is_xls = File.extname(file.original_filename) == ".xls"
    is_csv = File.extname(file.original_filename) == ".csv"
    imported = 0
    duplicates = 0

    if is_xlsx
      xlsx_file = nil

      xlsx_file = params[:contact][:upload_file]
      if params[:contact][:upload_file].is_a? ActionDispatch::Http::UploadedFile
        xlsx_file = params[:contact][:upload_file].tempfile
      end

      doc = SimpleXlsxReader.open(xlsx_file)          
      contacts = doc.sheets.first.rows[1..doc.sheets.first.rows.length]     
      puts ">>>>>>>>>>>>>> #{contacts}" 
      # contacts = contacts.collect { |r| [r.first,r.last] }  
      import_contacts contacts      

      # render json: { success: true, imported: imported, duplicates: duplicates }
      redirect_to contacts_path, notice: "Import successful"
    elsif is_csv
      csv_text = nil
      if !params[:contact][:upload_file].is_a? ActionDispatch::Http::UploadedFile
        csv_text = File.read(params[:contact][:upload_file])
      else
        csv_text = File.read(params[:contact][:upload_file].tempfile)
      end

      csv = CSV.parse(csv_text, :headers => true)   
      contacts = csv.collect { |r| [r[0],r[1]] }
      import_contacts contacts      

      # render json: { success: true, imported: imported, duplicates: duplicates }
      redirect_to contacts_path, notice: "Import successful"
   elsif is_xls
      if file.is_a? ActionDispatch::Http::UploadedFile
        xls_file = file.tempfile
      else
        xls_file = file
      end
      Spreadsheet.open(xls_file.path) do |book|
        contacts = book.worksheet(0).collect { |r| [r[0],r[1].to_i.to_s ] }
        import_contacts contacts[1..contacts.length]        
      end
      # render json: { success: true, imported: imported, duplicates: duplicates }
      redirect_to contacts_path, notice: "Import successful"
    else
      render json: { success: false, error: "Not a valid contacts file" }
    end
  end

  def import_contacts array
    # :name, :dob, :join_date :admission_number, :group, :previous_school, :last_exam_score, guardian -> name, phone_number, address, id_number
    array.each do |element|
      puts element
      if !element.include?(nil)
        name = element[0]
        if Contact.find_by(phone_number: element[1]).nil?
          contact = Contact.create! name: name, phone_number: element[1], location: element[2]
        end
      end
    end
  end

  def add_to_group
    added = 0
    group = Group.find_by(name: params[:group])
    if !group.nil?
      params[:contacts].split(',').each do |id|
        Contact.find_by(id: id).update(group_id: group.id)
        added += 1
      end
      redirect_to contacts_path, notice: "You have added #{added} contacts to #{group.name}."
    else
      redirect_to contacts_path, notice: "Please select a group to add the contacts to."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :phone_number, :location)
    end
end
