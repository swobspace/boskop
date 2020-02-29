require 'rails_helper'

RSpec.describe "software_raw_data/index", type: :view do
  before(:each) do
    assign(:software_raw_data, [
      SoftwareRawDatum.create!(
        software: nil,
        name: "Name",
        version: "Version",
        vendor: "Vendor",
        count: 2,
        operation_system: "Operation System",
        source: "Source"
      ),
      SoftwareRawDatum.create!(
        software: nil,
        name: "Name",
        version: "Version",
        vendor: "Vendor",
        count: 2,
        operation_system: "Operation System",
        source: "Source"
      )
    ])
  end

  it "renders a list of software_raw_data" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Version".to_s, count: 2
    assert_select "tr>td", text: "Vendor".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Operation System".to_s, count: 2
    assert_select "tr>td", text: "Source".to_s, count: 2
  end
end
