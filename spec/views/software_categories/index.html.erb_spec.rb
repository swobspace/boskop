require 'rails_helper'

RSpec.describe "software_categories/index", type: :view do
  before(:each) do
    assign(:software_categories, [
      SoftwareCategory.create!(
        name: "Name",
        description: "MyText",
        main_business_process: "MyText"
      ),
      SoftwareCategory.create!(
        name: "Name",
        description: "MyText",
        main_business_process: "MyText"
      )
    ])
  end

  it "renders a list of software_categories" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
