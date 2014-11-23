require 'rails_helper'

RSpec.describe "Merkmale", :type => :feature do
  describe "GET /merkmale" do
    it "visits merkmale#index" do
      login_admin
      visit merkmale_path
      expect(current_path).to eq(merkmale_path)
    end
  end
end
