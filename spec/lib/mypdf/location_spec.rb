require 'rails_helper'
require 'mypdf'

describe MyPDF::Location do
  let(:location) { FactoryGirl.create(:location,
    lid: "XYZ",
    name: "Anywhere GmbH Hollerdei",
    description: "MyDescription",
  )}
  let(:address1) { FactoryGirl.create(:address,
    ort: "Anywhere",
    plz: "12345",
    streetaddress: "Offroad 14",
  )}
  let(:address2) { FactoryGirl.create(:address,
    ort: "Nirgendwo",
    plz: "67890",
    streetaddress: "Holzweg 7",
  )}
  let(:network1) { FactoryGirl.create(:network,
    netzwerk: "192.168.178.0/24",
    description: "Fritzbox Default",
  )}
  let(:network2) { FactoryGirl.create(:network,
    netzwerk: "172.16.16.0/21",
    description: "Internes Netzwerk",
  )}
  let(:rendered_pdf) {
      pdf = MyPDF::Location.new(location)
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
    location.addresses << address1
    location.addresses << address2
    location.networks << network1
    location.networks << network2
  end

  describe "when creating PDF for Location" do
    it { expect(full_text).to match(/XYZ/) }
    it { expect(full_text).to match(/Anywhere GmbH Hollerdei/) }
    it { expect(full_text).to match("MyDescription") }
    it { expect(full_text).to match("12345 Anywhere") }
    it { expect(full_text).to match("67890 Nirgendwo") }
    it { expect(full_text).to match("Holzweg 7") }
    it { expect(full_text).to match("Offroad 14") }
    it { expect(full_text).to match("192.168.178.0/24") }
    it { expect(full_text).to match("172.16.16.0/21") }
    it { expect(full_text).to match("Internes Netzwerk") }
    it { expect(full_text).to match("Fritzbox Default") }

    context "text on first page" do
      let(:text) { pages.first.text }
      it { expect(text).to match(/XYZ/) }
      it { expect(text).to match(/Anywhere GmbH Hollerdei/) }
    end
  end
end
