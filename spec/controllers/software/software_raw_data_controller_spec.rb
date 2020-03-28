require 'rails_helper'

RSpec.describe Software::SoftwareRawDataController, type: :controller do
  login_admin
  let(:sw) { FactoryBot.create(:software) }

  let(:valid_attributes) {
    FactoryBot.attributes_for(:software_raw_datum, software_id: sw.id)
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  let(:valid_session) { {} }

  describe "PATCH #remove" do
    it "removes the software_id from requested software_raw_datum" do
      software_raw_datum = SoftwareRawDatum.create! valid_attributes
      patch :remove, params: {id: software_raw_datum.to_param, software_id: sw.id}, session: valid_session
      software_raw_datum.reload
      expect(software_raw_datum.software_id).to be_nil
    end

    it "redirects to the software_raw_data list" do
      software_raw_datum = SoftwareRawDatum.create! valid_attributes
      patch :remove, params: {id: software_raw_datum.to_param, software_id: sw.id}, session: valid_session
      software_raw_datum.reload
      expect(response).to redirect_to(software_url(sw))
    end
  end


end
