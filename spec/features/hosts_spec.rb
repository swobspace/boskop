require 'rails_helper'

RSpec.describe "Hosts", type: :feature do
  describe "GET /hosts" do
    it "visits hosts#index" do
      login_user
      visit hosts_path
      expect(current_path).to eq(hosts_path)
    end
  end
end
