require 'rails_helper'

RSpec.describe "FrameworkContracts", type: :request do
  describe "GET /framework_contracts" do
    it "works! (now write some real specs)" do
      get framework_contracts_path
      expect(response).to have_http_status(200)
    end
  end
end
