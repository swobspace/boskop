require 'rails_helper'

RSpec.describe "software_raw_data/show", type: :view do
  before(:each) do
    @software_raw_datum = assign(:software_raw_datum, SoftwareRawDatum.create!(
      software: nil,
      name: "Name",
      version: "Version",
      vendor: "Vendor",
      count: 2,
      operating_system: "Operating System",
      source: "Source"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Version/)
    expect(rendered).to match(/Vendor/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Operating System/)
    expect(rendered).to match(/Source/)
  end
end
