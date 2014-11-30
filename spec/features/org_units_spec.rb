require 'rails_helper'

RSpec.describe "OrgUnits", :type => :feature do
  describe "GET /org_units" do
    it "visits org_units#index" do
      login_user
      visit org_units_path
      expect(current_path).to eq(org_units_path)
    end

  end
end
