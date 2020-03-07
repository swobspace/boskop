require 'rails_helper'

RSpec.describe "SoftwareRawData", type: :feature do
  describe "GET /software_raw_data" do
   it "visits software_raw_data#index" do
      login_user
      visit software_raw_data_path
      expect(current_path).to eq(software_raw_data_path)
    end

  end
end
