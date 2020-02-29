require 'rails_helper'

RSpec.describe "software_categories/show", type: :view do
  before(:each) do
    @software_category = assign(:software_category, SoftwareCategory.create!(
      name: "Name",
      description: "MyText",
      main_business_process: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
