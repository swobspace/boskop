require 'rails_helper'

RSpec.describe "SoftwareCategories", type: :feature do
  describe "GET /software_categories" do
    it "visits software_categories#index" do
      login_user
      visit software_categories_path
      expect(current_path).to eq(software_categories_path)
    end
  end
end
