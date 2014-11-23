require 'rails_helper'

RSpec.describe "Merkmalklassen", :type => :feature do
  describe "GET /merkmalklassen" do
    it "visits merkmalklassen#index" do
      login_admin
      visit merkmalklassen_path
      expect(current_path).to eq(merkmalklassen_path)
    end
  end
end
