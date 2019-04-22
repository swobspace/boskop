require 'rails_helper'

RSpec.describe "NetworkInterfaces", type: :feature do
  describe "GET /network_interfaces" do
    it "visits network_interfaces#index" do
      login_user
      visit network_interfaces_path
      expect(current_path).to eq(network_interfaces_path)
    end
  end
end
