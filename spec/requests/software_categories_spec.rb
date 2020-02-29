require 'rails_helper'

RSpec.describe "SoftwareCategories", type: :request do
  describe "GET /software_categories" do
    it "works! (now write some real specs)" do
      get software_categories_path
      expect(response).to have_http_status(200)
    end
  end
end
