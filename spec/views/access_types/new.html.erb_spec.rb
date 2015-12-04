require 'rails_helper'

RSpec.describe "access_types/new", type: :view do
  before(:each) do
    assign(:access_type, AccessType.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new access_type form" do
    render

    assert_select "form[action=?][method=?]", access_types_path, "post" do

      assert_select "input#access_type_name[name=?]", "access_type[name]"

      assert_select "textarea#access_type_description[name=?]", "access_type[description]"
    end
  end
end
