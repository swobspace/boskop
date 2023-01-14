require 'rails_helper'

RSpec.describe "Lines", type: :feature do
  fixtures :locations, :access_types, :line_states

  describe "GET /lines" do
    it "visits lines#index" do
      login_user
      visit lines_path
      expect(current_path).to eq(lines_path)
    end
  end

  describe "Create a line" do
    it "visits lines#new" do
      login_admin
      visit new_line_path
      fill_in "Name", with: "BER-MPLS-001"
      fill_in "Beschreibung", with: "some description"
      select "Berlin", from: "Standort A"
      select "MPLS", from: "Zugangsart"
      select "active", from: "Status"
      click_button "Leitung/Zugang erstellen"
      expect(page).to have_content("Leitung/Zugang erfolgreich erstellt")
      expect(page).to have_content("Leitung/Zugang: BER-MPLS-001")
      expect(page).to have_content("MPLS")
      expect(page).to have_content("active")
    end
  end

  describe "with existing line" do
    let!(:line) { FactoryBot.create(:line, name: "PAR-XYZ", location_a: locations(:paris)) }
    it "visits lines#show" do
      login_admin
      visit line_path(line)
      expect(page).to have_content("PAR-XYZ")
      expect(page).to have_content("Paris")
    end


    it "delete an existing line", js: true do
      login_admin
      visit line_path(line)
      expect(page).to have_content("Paris")
      expect(page).to have_content("PAR-XYZ")
      accept_confirm do
        find('a[title="Leitung/Zugang löschen"]').click
      end
      expect(page).to have_content("Leitung/Zugang erfolgreich gelöscht")
    end
  end

end
