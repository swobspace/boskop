require 'rails_helper'

RSpec.describe "MacPrefixes", type: :feature do
  describe "GET /mac_prefixes" do
    it "visits org_units#index" do
      login_user
      visit mac_prefixes_path
      expect(current_path).to eq(mac_prefixes_path)
    end
  end
end
