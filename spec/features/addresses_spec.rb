require 'rails_helper'

RSpec.describe "Addresses", :type => :feature do
  describe "GET /addresses" do
    it "visits addresses#index" do
      login_admin
      visit addresses_path
      expect(current_path).to eq(addresses_path)
    end
  end
end
