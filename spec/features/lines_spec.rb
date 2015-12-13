require 'rails_helper'

RSpec.describe "Lines", type: :feature do
  describe "GET /lines" do
    it "visits lines#index" do
      login_user
      visit lines_path
      expect(current_path).to eq(lines_path)
    end
  end
end
