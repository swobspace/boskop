require 'rails_helper'

RSpec.describe "Locations", :type => :feature, js: true do
  fixtures :merkmalklassen, :locations
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

  describe "Show location" do
    it "visits locations#standort" do
      login_admin
      visit location_path(locations(:nimmerland))
      expect(page).to have_content("Standort: Nimmerland")
      expect(page).to have_content("NIL")
      expect(page).to have_content("Zugeordnete Netzwerke")
      expect(page).to have_content("Zugeordnete Leitungen/Zugänge")
    end
  end

  describe "Show and delete location" do
    let!(:location) { FactoryBot.create(:location, name: "Stromboli", lid: "STR") }
    it "visits locations#show" do
      login_admin
      visit location_path(locations(:nimmerland))
      expect(page).to have_content("Standort: Nimmerland")
      expect(page).to have_content("NIL")
      expect(page).to have_content("Zugeordnete Netzwerke")
      expect(page).to have_content("Zugeordnete Leitungen/Zugänge")
    end

    it "delete an existing location", js: true do
      login_admin
      visit location_path(location)
      expect(page).to have_content("Standort: Stromboli")
      expect(page).to have_content("STR")
      accept_confirm do
        find('a[title="Standort löschen"]').click
      end
      expect(page).to have_content("Standort erfolgreich gelöscht")
    end
  end

end
