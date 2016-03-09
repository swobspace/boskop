require 'rails_helper'
require 'mypdf'

describe MyPDF::Line do
  let(:line)     { FactoryGirl.create(:line,
    name: "XYZ-TDN-001",
    location_a: location,
  )}
  let(:location) { FactoryGirl.create(:location,
    lid: "XYZ",
    name: "Anywhere GmbH Hollerdei",
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
    context "text on first page" do
      let(:text) { pages.first.text }
      it { expect(text).to match(/XYZ/) }
      it { expect(text).to match(/Anywhere GmbH Hollerdei/) }
    end
  end
end
