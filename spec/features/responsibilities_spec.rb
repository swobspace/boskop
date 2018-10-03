require 'rails_helper'

RSpec.describe "Responsibilities", type: :feature do
  describe "GET /responsibilities" do
    it "visits responsibilities#index" do
      login_user
      visit responsibilities_path
      expect(current_path).to eq(responsibilities_path)
    end
  end
end
