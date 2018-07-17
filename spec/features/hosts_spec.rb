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
      within "form" do
        select 'XML', :from => 'type'
        select 'Newer', :from => 'update'
        attach_file('file', nmapfile)
        click_button "Upload"
      end
      expect(page).to have_content("Hosts")
      expect(page).to have_content("Import successful")
    end
  end
end
