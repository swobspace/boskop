require 'rails_helper'

RSpec.describe SoftwareRawDataController, type: :controller do
  login_admin

  let(:csv_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'raw_software.csv') }

  let(:valid_attributes) {
    FactoryBot.attributes_for(:software_raw_datum)
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      SoftwareRawDatum.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #search" do
    context "with default format" do
      it "returns a success response" do
        SoftwareRawDatum.create! valid_attributes
        get :search, params: {name: 'anything'}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "with format :csv" do
      it "returns a success response" do
        pending "not yet implemented"
        SoftwareRawDatum.create! valid_attributes
        get :search, params: {name: 'anything', format: :csv}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      software_raw_datum = SoftwareRawDatum.create! valid_attributes
      get :show, params: {id: software_raw_datum.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new_import" do
    it "returns a success response" do
      get :new_import, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #search_form" do
    it "returns a success response" do
      get :search_form, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      software_raw_datum = SoftwareRawDatum.create! valid_attributes
      get :edit, params: {id: software_raw_datum.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #import" do
    context "with valid params" do
      let(:import_form_attributes) {{ file: csv_file, lastseen: Date.today, source: "Unknown" }}
      it "imports raw software data from csv" do
        expect {
          post :import, params: import_form_attributes, session: valid_session
        }.to change(SoftwareRawDatum, :count).by(4)
      end

      it "redirects to software_raw_data_path" do
        post :import, params: import_form_attributes, session: valid_session
        expect(response).to redirect_to(software_raw_data_path)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new SoftwareRawDatum" do
        expect {
          post :create, params: {software_raw_datum: valid_attributes}, session: valid_session
        }.to change(SoftwareRawDatum, :count).by(1)
      end

      it "redirects to the created software_raw_datum" do
        post :create, params: {software_raw_datum: valid_attributes}, session: valid_session
        expect(response).to redirect_to(SoftwareRawDatum.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {software_raw_datum: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    let(:sw) { FactoryBot.create(:software) }
    context "with valid params" do
      let(:new_attributes) {{
        "software_id" => sw.id,
        "version" => "1704",
        "vendor" => "Universe Ltd.",
        "count" => 554,
        "operating_system" => "Windows",
        "lastseen" => Date.today,
        "source" => "docusnap"
      }}

      it "updates the requested software_raw_datum" do
        software_raw_datum = SoftwareRawDatum.create! valid_attributes
        put :update, params: {id: software_raw_datum.to_param, software_raw_datum: new_attributes}, session: valid_session
        software_raw_datum.reload
        expect(software_raw_datum.attributes).to include(new_attributes)
      end

      it "redirects to the software_raw_datum" do
        software_raw_datum = SoftwareRawDatum.create! valid_attributes
        put :update, params: {id: software_raw_datum.to_param, software_raw_datum: valid_attributes}, session: valid_session
        expect(response).to redirect_to(software_raw_datum)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_raw_datum = SoftwareRawDatum.create! valid_attributes
        put :update, params: {id: software_raw_datum.to_param, software_raw_datum: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested software_raw_datum" do
      software_raw_datum = SoftwareRawDatum.create! valid_attributes
      expect {
        delete :destroy, params: {id: software_raw_datum.to_param}, session: valid_session
      }.to change(SoftwareRawDatum, :count).by(-1)
    end

    it "redirects to the software_raw_data list" do
      software_raw_datum = SoftwareRawDatum.create! valid_attributes
      delete :destroy, params: {id: software_raw_datum.to_param}, session: valid_session
      expect(response).to redirect_to(software_raw_data_url)
    end
  end

end
