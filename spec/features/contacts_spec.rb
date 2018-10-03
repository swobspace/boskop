require 'rails_helper'

RSpec.describe "Contacts", type: :feature do
  describe "GET /contacts" do
    it "visits contacts#index" do
      login_user
      visit contacts_path
      expect(current_path).to eq(contacts_path)
    end
  end
end
