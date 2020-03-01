require 'rails_helper'

RSpec.describe "software/show", type: :view do
  before(:each) do
    @software = assign(:software, Software.create!(
      name: "Name",
      pattern: "MyText",
      vendor: "Vendor",
      description: "MyText",
      minimum_allowed_version: "Minimum Allowed Version",
      maximum_allowed_version: "Maximum Allowed Version",
      software_category: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Vendor/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Minimum Allowed Version/)
    expect(rendered).to match(/Maximum Allowed Version/)
    expect(rendered).to match(//)
  end
end
