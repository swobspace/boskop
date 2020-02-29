require 'rails_helper'

RSpec.describe "Softwares", type: :request do
  describe "GET /softwares" do
    it "works! (now write some real specs)" do
      get softwares_path
      expect(response).to have_http_status(200)
    end
  end
end
