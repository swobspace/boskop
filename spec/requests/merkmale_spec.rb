require 'rails_helper'

RSpec.describe "Merkmale", :type => :request do
  describe "GET /merkmale" do
    it "works! (now write some real specs)" do
      get merkmale_path
      expect(response).to have_http_status(200)
    end
  end
end
