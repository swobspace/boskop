require 'rails_helper'

RSpec.describe "Locations", :type => :feature do
  fixtures :merkmalklassen
  describe "GET /locations" do
    it "visits locations#index" do
      login_user
      visit locations_path
      expect(current_path).to eq(locations_path)
    end
  end

  describe "Create a location" do
    it "visits locations#new" do
      login_admin
      visit new_location_path
      fill_in "Name", with: "Nirgendwo"
      fill_in "StandortID", with: "JWD"
      click_button "Standort erstellen"
      expect(page).to have_content("Standort konnte nicht angelegt werden")
      expect(page).to have_content("Wert muss ausgefüllt werden")
      fill_in "location phone", with: "01234 567-890"
      click_button "Standort erstellen"
      expect(page).to have_content("Standort erfolgreich erstellt")
      expect(page).to have_content("Nirgendwo")
      expect(page).to have_content("JWD")
    end
  end
end
