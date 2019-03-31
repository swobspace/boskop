require 'rails_helper'

RSpec.describe "NetworkInterfaces", type: :request do
  describe "GET /network_interfaces" do
    it "works! (now write some real specs)" do
      get network_interfaces_path
      expect(response).to have_http_status(200)
    end
  end
end
