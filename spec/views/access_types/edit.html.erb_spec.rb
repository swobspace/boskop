require 'rails_helper'

RSpec.describe "access_types/edit", type: :view do
  before(:each) do
    @access_type = assign(:access_type, AccessType.create!(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit access_type form" do
    render

    assert_select "form[action=?][method=?]", access_type_path(@access_type), "post" do

      assert_select "input#access_type_name[name=?]", "access_type[name]"

      assert_select "textarea#access_type_description[name=?]", "access_type[description]"
    end
  end
end
