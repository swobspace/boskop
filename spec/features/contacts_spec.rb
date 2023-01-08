require 'rails_helper'

RSpec.describe "Contacts", type: :feature do
  describe "GET /contacts" do
    it "visits contacts#index" do
      login_user
      visit contacts_path
      expect(current_path).to eq(contacts_path)
    end
  end

  describe "New contact form" do
    it "visits contacts#new" do
      login_admin
      visit new_contact_path
      expect(current_path).to eq(new_contact_path)
      expect(page).to have_content("Nachname")
      click_on "Adresse"
      expect(page).to have_content("Straße, Nr.")
      click_on "Kommunikation"
      expect(page).to have_content("E-Mail")
    end
  end

  describe "Show contact" do
    let!(:contact) {FactoryBot.create(:contact, sn: 'Mustermann', givenname: 'Max', mail: 'mmax@mustermann.de')}
    it "visits contacts#show" do
      login_admin
      visit contact_path(contact)
      expect(current_path).to eq(contact_path(contact))
      expect(page).to have_content("Mustermann")
      expect(page).to have_content("Max")
      click_on "Adresse"
      expect(page).to have_content("Straße, Nr.")
      click_on "Kommunikation"
      expect(page).to have_content("E-Mail")
      expect(page).to have_content("mmax@mustermann.de")
    end
  end
end
