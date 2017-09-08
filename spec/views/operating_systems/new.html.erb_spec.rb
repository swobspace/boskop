require 'rails_helper'

RSpec.describe "operating_systems/new", type: :view do
  before(:each) do
    assign(:operating_system, OperatingSystem.new(
      :name => "MyString",
      :matching_pattern => "MyText"
    ))
  end

  it "renders new operating_system form" do
    render

    assert_select "form[action=?][method=?]", operating_systems_path, "post" do

      assert_select "input[name=?]", "operating_system[name]"

      assert_select "textarea[name=?]", "operating_system[matching_pattern]"
    end
  end
end
