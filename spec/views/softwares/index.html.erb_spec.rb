require 'rails_helper'

RSpec.describe "softwares/index", type: :view do
  before(:each) do
    assign(:softwares, [
      Software.create!(
        name: "Name",
        pattern: "MyText",
        vendor: "Vendor",
        description: "MyText",
        minimum_allowed_version: "Minimum Allowed Version",
        maximum_allowed_version: "Maximum Allowed Version",
        software_category: nil
      ),
      Software.create!(
        name: "Name",
        pattern: "MyText",
        vendor: "Vendor",
        description: "MyText",
        minimum_allowed_version: "Minimum Allowed Version",
        maximum_allowed_version: "Maximum Allowed Version",
        software_category: nil
      )
    ])
  end

  it "renders a list of softwares" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Vendor".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Minimum Allowed Version".to_s, count: 2
    assert_select "tr>td", text: "Maximum Allowed Version".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
