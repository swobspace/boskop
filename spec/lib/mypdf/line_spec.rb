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

  before(:each) do
    # stub_const("Settings", FakeSettings)
  end

  context "when creating PDF for Line" do
    let(:full_text) {
      pdf = MyPDF::Line.new(line)
      pdf.render_output
      rendered_pdf = pdf.render
      full_text = PDF::Inspector::Text.analyze(rendered_pdf).strings.join(" ")
    }

    it { expect(full_text).to match(/XYZ/) }
    it { expect(full_text).to match(/Anywhere GmbH Hollerdei/) }
  end
end
