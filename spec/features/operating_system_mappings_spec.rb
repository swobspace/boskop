require 'rails_helper'

RSpec.describe "OperatingSystemMappings", type: :feature do
  describe "GET /operating_system_mappings" do
    it "visits operating_system_mappings#index" do
      login_user
      visit operating_system_mappings_path
      expect(current_path).to eq(operating_system_mappings_path)
    end
  end
end
