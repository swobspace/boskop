require 'rails_helper'

RSpec.describe "Vulnerabilities", type: :feature do
  describe "GET /vulnerabilities" do
    it "visits vulnerability_details#index" do
      login_user
      visit vulnerabilities_path
      expect(current_path).to eq(vulnerabilities_path)
    end
  end

  describe "with import nessus xml file", js: false do
    let(:nessusfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'cry-nessus.xml')}
    it "uploads vulnerabilities" do
      login_admin
      visit vulnerabilities_path
      click_link "Schwachstellenscan importieren"
      within "form" do
        select 'Nessus', :from => 'type'
        attach_file('file', nessusfile)
        click_button "Upload"
      end
      expect(page).to have_content("Schwachstellen")
      expect(page).to have_content("Import successful")
    end
  end
end
