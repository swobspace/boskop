require 'rails_helper'

RSpec.describe "Hosts", type: :feature do
  describe "GET /hosts" do
    it "visits hosts#index" do
      login_user
      visit hosts_path
      expect(current_path).to eq(hosts_path)
    end
  end

  describe "with import nmap xml file", js: false do
    let(:nmapfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-42.xml')}
    it "uploads hosts" do
      login_admin
      visit hosts_path
      click_link "Hosts aus Datei importieren"
      within "form.card" do
        select 'XML', :from => 'type'
        select 'Newer', :from => 'update'
        attach_file('file', nmapfile)
        click_button "Upload"
      end
      expect(page).to have_content("Hosts")
      expect(page).to have_content("Import successful")
    end
  end


  describe "Create a host" do
    it "visits hosts#new" do
      login_admin
      visit new_host_path
      fill_in "Name", with: "ABC-SRV-003"
      fill_in "zuletzt gesehen", with: '2023-01-01'
      click_button "Host erstellen"
      expect(page).to have_content("Host erfolgreich erstellt")
      expect(page).to have_content("Host: (ABC-SRV-003)")
      expect(page).to have_content("2023-01-01")
      expect(page).to have_content("Netzwerk-Interfaces")
    end
  end

  describe "Show and delete host" do
    let!(:host) { FactoryBot.create(:host, name: "ABC-SRV-003", lastseen: Date.current) }

    it "visits hosts#show" do
      login_admin
      visit host_path(host)
      expect(page).to have_content("Host: (ABC-SRV-003)")
      expect(page).to have_content("zuletzt gesehen")
      expect(page).to have_content(Date.current.to_s)
      expect(page).to have_content("Netzwerk-Interfaces")
      expect(page).to have_content("Schwachstellen (Kritisch)")
    end

    it "delete an existing host", js: true do
      login_admin
      visit host_path(host)
      expect(page).to have_content("Host: (ABC-SRV-003)")
      expect(page).to have_content(Date.current.to_s)
      accept_confirm do
        find('a[title="Host löschen"]').click
      end
      expect(page).to have_content("Host erfolgreich gelöscht")
    end
  end

end
