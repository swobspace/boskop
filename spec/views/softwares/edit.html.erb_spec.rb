require 'rails_helper'

RSpec.describe "softwares/edit", type: :view do
  before(:each) do
    @software = assign(:software, Software.create!(
      name: "MyString",
      pattern: "MyText",
      vendor: "MyString",
      description: "MyText",
      minimum_allowed_version: "MyString",
      maximum_allowed_version: "MyString",
      software_category: nil
    ))
  end

  it "renders the edit software form" do
    render

    assert_select "form[action=?][method=?]", software_path(@software), "post" do

      assert_select "input[name=?]", "software[name]"

      assert_select "textarea[name=?]", "software[pattern]"

      assert_select "input[name=?]", "software[vendor]"

      assert_select "textarea[name=?]", "software[description]"

      assert_select "input[name=?]", "software[minimum_allowed_version]"

      assert_select "input[name=?]", "software[maximum_allowed_version]"

      assert_select "input[name=?]", "software[software_category_id]"
    end
  end
end
