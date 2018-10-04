class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /contacts
  def index
    respond_with(@contacts)
  end

  # GET /contacts/1
  def show
    respond_with(@contact)
  end

  # GET /contacts/new
  def new
    @contact = Contact.new(new_contact_params)
    respond_with(@contact)
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    @contact.save
    respond_with(@contact)
  end

  # PATCH/PUT /contacts/1
  def update
    @contact.update(contact_params)
    respond_with(@contact)
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    respond_with(@contact)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(
        :sn, :givenname, :displayname, :title, :anrede, :position, 
        :streetaddress, :plz, :ort, :postfach, :postfachplz, :care_of, 
        :telephone, :telefax, :mobile, :mail, :internet,
        responsibilities_attributes: [
          :id, :_destroy,
          :responsibility_for_type, :responsibility_for_id, :role, :title, :position
        ]
      )
    end

    def new_contact_params
      params.slice(:sn, :givenname, :displayname, :title, :anrede, :position, :streetaddress, :plz, :ort, :postfach, :postfachplz, :care_of, :telephone, :telefax, :mobile, :mail, :internet).permit!
    end

end
