require 'rails_helper'

RSpec.describe "AccessTypes", type: :request do
  describe "GET /access_types" do
    it "works! (now write some real specs)" do
      get access_types_path
      expect(response).to have_http_status(200)
    end
  end
end
