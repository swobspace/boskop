require 'rails_helper'

RSpec.describe "software_categories/new", type: :view do
  before(:each) do
    assign(:software_category, SoftwareCategory.new(
      name: "MyString",
      description: "MyText",
      main_business_process: "MyText"
    ))
  end

  it "renders new software_category form" do
    render

    assert_select "form[action=?][method=?]", software_categories_path, "post" do

      assert_select "input[name=?]", "software_category[name]"

      assert_select "textarea[name=?]", "software_category[description]"

      assert_select "textarea[name=?]", "software_category[main_business_process]"
    end
  end
end
