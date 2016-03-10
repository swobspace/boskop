require 'rails_helper'
require 'mypdf'

describe MyPDF::Line do
  let(:line)     { FactoryGirl.create(:line,
    name: "XYZ-TDN-001",
    location_a: location,
    location_b: loc_b,
    description: "MyDescription",
    notes: "MyNotes",
    provider_id: "myProviderNumber",
    bw_downstream: 20,
    bw_upstream: 4,
    bw2_downstream: 16,
    bw2_upstream: 2.8,
    contract_start: "2015-01-01",
    contract_end: "2017-12-31",
    contract_period: "3 years",
    period_of_notice: 3,
    period_of_notice_unit: "month",
    renewal_period: 2,
    renewal_unit: "year"
  )}
  let(:location) { FactoryGirl.create(:location,
    lid: "XYZ",
    name: "Anywhere GmbH Hollerdei",
  )}
  let(:loc_b) { FactoryGirl.create(:location,
    lid: "LOCB",
    name: "Anywhere GmbH Milkway",
  )}
  let(:rendered_pdf) {
      pdf = MyPDF::Line.new(line)
      pdf.render_output
      pdf.render
  }
  let(:full_text) {
    full_text = PDF::Inspector::Text.analyze(rendered_pdf).strings.join(" ")
  }
  let(:pages) {
    reader = PDF::Reader.new(StringIO.new(rendered_pdf))
    reader.pages
  }

  before(:each) do
    # stub_const("Settings", FakeSettings)
  end

  describe "when creating PDF for Line" do
    it { expect(full_text).to match(/XYZ/) }
    it { expect(full_text).to match(/Anywhere GmbH Hollerdei/) }
    it { expect(full_text).to match(location.to_string) }
    it { expect(full_text).to match(loc_b.to_string) }
    it { expect(full_text).to match("MyDescription") }
    it { expect(full_text).to match("MyNotes") }
    it { expect(full_text).to match("myProviderNumber") }
    it { expect(full_text).to match("XYZ-TDN-001") }
    it { expect(full_text).to match("20.0/4.0 Mbit primary") }
    it { expect(full_text).to match("16.0/2.8 Mbit secondary") }

    it "displays contract name" do
      expect(line).to receive(:framework_contract).and_return("Rahmenvertrag 1704")
      expect(full_text).to match("Rahmenvertrag 1704")
    end

    it "displays access_type" do
      expect(line).to receive(:access_type).at_least(:once).and_return("MPLS")
      expect(full_text).to match("MPLS")
    end

    it "displays line state" do
      expect(line).to receive(:line_state).and_return("current")
      expect(full_text).to match("current")
    end

    context "text on first page" do
      let(:text) { pages.first.text }
      it { expect(text).to match(/XYZ/) }
      it { expect(text).to match(/Anywhere GmbH Hollerdei/) }
    end
  end
end
