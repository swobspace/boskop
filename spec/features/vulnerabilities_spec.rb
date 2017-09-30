require 'rails_helper'

RSpec.describe "Vulnerabilities", type: :feature do
  describe "GET /vulnerabilities" do
    it "visits vulnerability_details#index" do
      login_user
      visit vulnerabilities_path
      expect(current_path).to eq(vulnerabilities_path)
    end
  end
end
