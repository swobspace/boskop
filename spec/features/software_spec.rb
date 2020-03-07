require 'rails_helper'

RSpec.describe "Software", type: :feature do
  describe "GET /software" do
   it "visits software#index" do
      login_user
      visit software_index_path
      expect(current_path).to eq(software_index_path)
    end
  end
end
