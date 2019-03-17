require "rails_helper"

RSpec.describe NessusScansHelper, :type => :helper do

  describe "#import_nessus_link" do
    let(:nessus_scan) { FactoryBot.create(:nessus_scan) }
    subject { Capybara.string(helper.import_nessus_link(nessus_scan)) }
    it { expect(subject.find("a")['href']).to match(import_nessus_scan_path(nessus_scan)) }
    it { expect(subject.find("a")['class']).to match("btn btn-secondary") }
  end

end
