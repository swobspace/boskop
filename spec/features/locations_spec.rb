require 'rails_helper'

RSpec.describe "Locations", :type => :feature do
  describe "GET /locations" do
    it "visits locations#index" do
      login_user
      visit locations_path
      expect(current_path).to eq(locations_path)
    end
  end
end
