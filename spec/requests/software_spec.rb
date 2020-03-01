require 'rails_helper'

RSpec.describe "Software", type: :request do
  describe "GET /software" do
    it "works! (now write some real specs)" do
      get software_path
      expect(response).to have_http_status(200)
    end
  end
end
