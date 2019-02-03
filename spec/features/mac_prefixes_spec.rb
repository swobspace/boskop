require 'rails_helper'

RSpec.describe "MacPrefixes", type: :request do
  describe "GET /mac_prefixes" do
    it "works! (now write some real specs)" do
      get mac_prefixes_path
      expect(response).to have_http_status(200)
    end
  end
end
