require 'rails_helper'

RSpec.describe "FrameworkContracts", type: :feature do
  describe "GET /framework_contracts" do
    it "visits framework_contracts#index" do
      login_user
      visit framework_contracts_path
      expect(current_path).to eq(framework_contracts_path)
    end
  end
end
