require 'rails_helper'

RSpec.describe "Networks", :type => :feature do
  fixtures :locations
  let!(:net1) {FactoryBot.create(:network, netzwerk: '192.168.1.64/27')}
  let!(:net2) {FactoryBot.create(:network, netzwerk: '192.168.0.0/23')}
  let!(:net3) {FactoryBot.create(:network, netzwerk: '192.168.7.0/24')}

  describe "GET /networks" do
    it "visits networks#index" do
      login_user
      visit networks_path
      expect(current_path).to eq(networks_path)
    end

    it "search for subsets of '192.168.1.0/24' get '192.168.1.64/27'" do
      login_user
      visit search_form_networks_path
      within 'form.card' do
        fill_in 'netzwerk', with: '192.168.1.0/24'
        check 'is_subset'
        uncheck 'is_superset'
        click_button 'Suche'
      end
      expect(page).to have_content "192.168.1.64/27"
      expect(page).not_to have_content "192.168.0.0/23"
      expect(page).not_to have_content "192.168.7.0/24"
    end

    it "search for supersets of '192.168.1.0/24' get '192.168.0.0/23'" do
      login_user
      visit search_form_networks_path
      within 'form.card' do
        fill_in 'netzwerk', with: '192.168.1.0/24'
        check 'is_superset'
        uncheck 'is_subset'
        click_button 'Suche'
      end
      expect(page).not_to have_content "192.168.1.64/27"
      expect(page).to have_content "192.168.0.0/23"
      expect(page).not_to have_content "192.168.7.0/24"
    end

    it "search for subset AND superset of '192.168.1.0/24' get '192.168.0.0/23' and '192.168.1.64/27'" do
      login_user
      visit search_form_networks_path
      within 'form.card' do
        fill_in 'netzwerk', with: '192.168.1.0/24'
        check 'is_subset'
        check 'is_superset'
        click_button 'Suche'
      end
      expect(page).to have_content "192.168.1.64/27"
      expect(page).to have_content "192.168.0.0/23"
      expect(page).not_to have_content "192.168.7.0/24"
    end

    it "search for '192.168.7.0/24'" do
      login_user
      visit search_form_networks_path
      within 'form.card' do
        fill_in 'netzwerk', with: '192.168.7.0/24'
        click_button 'Suche'
      end
      expect(page).not_to have_content "192.168.1.64/27"
      expect(page).not_to have_content "192.168.0.0/23"
      expect(page).to have_content "192.168.7.0/24"
    end
  end

  describe "Create a network" do
    it "visits networks#new" do
      login_admin
      visit new_network_path
      fill_in "Netzwerk", with: "198.51.100.64/26"
      fill_in "Beschreibung", with: "Demo-Netzwerk"
      select "BER", from: "Standort"
      click_button "Netzwerk erstellen"
      expect(page).to have_content("Netzwerk erfolgreich erstellt")
      expect(page).to have_content("198.51.100.64/26")
      expect(page).to have_content("Demo-Netzwerk")
      expect(page).to have_content("Berlin")
      expect(page).to have_content("BER")
    end
  end

  describe "Delete network" do
    let!(:network) do
      FactoryBot.create(:network, 
        netzwerk: "198.51.100.64/26",
        location: locations(:berlin)
      )
    end

    it "delete an existing network", js: true do
      login_admin
      visit network_path(network)
      expect(page).to have_content("198.51.100.64/26")
      expect(page).to have_content("BER")
      accept_confirm do
        find('a[title="Netzwerk löschen"]').click
      end
      expect(page).to have_content("Netzwerk erfolgreich gelöscht")
    end
  end

end
