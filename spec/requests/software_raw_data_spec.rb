require 'rails_helper'

RSpec.describe "SoftwareRawData", type: :request do
  describe "GET /software_raw_data" do
    it "works! (now write some real specs)" do
      get software_raw_data_path
      expect(response).to have_http_status(200)
    end
  end
end
