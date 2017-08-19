require 'rails_helper'

RSpec.describe "HostCategories", type: :feature do
  describe "GET /host_categories" do
    it "visits host_categories#index" do
      login_user
      visit host_categories_path
      expect(current_path).to eq(host_categories_path)
    end
  end
end
