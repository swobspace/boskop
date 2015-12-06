require 'rails_helper'

RSpec.describe "AccessTypes", type: :feature do
  describe "GET /access_types" do
    it "visits access_types#index" do
      login_user
      visit access_types_path
      expect(current_path).to eq(access_types_path)
    end
  end
end
