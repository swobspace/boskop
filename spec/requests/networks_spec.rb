require 'rails_helper'

RSpec.describe "Networks", :type => :request do
  describe "GET /networks" do
    it "works! (now write some real specs)" do
      get networks_path
      expect(response).to have_http_status(200)
    end
  end
end
