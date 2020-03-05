require 'rails_helper'

RSpec.describe SoftwareController, type: :controller do
  login_admin

  let(:valid_attributes) {
    FactoryBot.attributes_for(:software)
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Software.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      software = Software.create! valid_attributes
      get :show, params: {id: software.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      software = Software.create! valid_attributes
      get :edit, params: {id: software.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Software" do
        expect {
          post :create, params: {software: valid_attributes}, session: valid_session
        }.to change(Software, :count).by(1)
      end

      it "redirects to the created software" do
        post :create, params: {software: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Software.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {software: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    let(:swcat) { FactoryBot.create(:software_category) }
    context "with valid params" do
      let(:new_attributes) {{
        "pattern" => {'name' => '/\A7-zip.*\z/', 'vendor' => 'ACME Ltd'},
        "vendor" => "MyVendor",
        "description" => "MyDescription",
        "minimum_allowed_version" => "19.4",
        "maximum_allowed_version" => "999.0",
        "green" => 2.years.before(Date.today),
        "yellow" => 2.years.after(Date.today),
        "red" => 10.years.after(Date.today),
        "software_category_id" => swcat.id,
      }}

      it "updates the requested software" do
        software = Software.create! valid_attributes
        put :update, params: {id: software.to_param, software: new_attributes}, session: valid_session
        software.reload
        expect(software.attributes).to include(new_attributes)
      end

      it "redirects to the software" do
        software = Software.create! valid_attributes
        put :update, params: {id: software.to_param, software: valid_attributes}, session: valid_session
        expect(response).to redirect_to(software)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software = Software.create! valid_attributes
        put :update, params: {id: software.to_param, software: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested software" do
      software = Software.create! valid_attributes
      expect {
        delete :destroy, params: {id: software.to_param}, session: valid_session
      }.to change(Software, :count).by(-1)
    end

    it "redirects to the software list" do
      software = Software.create! valid_attributes
      delete :destroy, params: {id: software.to_param}, session: valid_session
      expect(response).to redirect_to(software_index_url)
    end
  end

end
