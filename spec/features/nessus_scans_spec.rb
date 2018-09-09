require 'rails_helper'

RSpec.describe "NessusScans", type: :feature do
  describe "GET /nessus_scans" do
    it "displays index page" do
      login_user
      visit nessus_scans_path
      expect(current_path).to eq(nessus_scans_path)
    end
  end
end
