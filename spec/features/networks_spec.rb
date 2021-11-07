require 'rails_helper'

RSpec.describe "Networks", :type => :feature do
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
      within 'form' do
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
      within 'form' do
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
      within 'form' do
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
      within 'form' do
        fill_in 'netzwerk', with: '192.168.7.0/24'
        click_button 'Suche'
      end
      expect(page).not_to have_content "192.168.1.64/27"
      expect(page).not_to have_content "192.168.0.0/23"
      expect(page).to have_content "192.168.7.0/24"
    end

  end
end
