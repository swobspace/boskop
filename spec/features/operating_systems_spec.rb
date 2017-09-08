require 'rails_helper'

RSpec.describe "OperatingSystems", type: :feature do
  describe "GET /operating_systems" do
    it "visits operating_systems#index" do
      login_user
      visit operating_systems_path
      expect(current_path).to eq(operating_systems_path)
    end
  end
end
