require 'rails_helper'

RSpec.describe "Networks", :type => :feature do
  describe "GET /networks" do
    it "visits networks#index" do
      login_user
      visit networks_path
      expect(current_path).to eq(networks_path)
    end
  end
end
