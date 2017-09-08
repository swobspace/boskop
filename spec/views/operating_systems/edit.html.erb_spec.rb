require 'rails_helper'

RSpec.describe "operating_systems/edit", type: :view do
  before(:each) do
    @operating_system = assign(:operating_system, OperatingSystem.create!(
      :name => "MyString",
      :matching_pattern => "MyText"
    ))
  end

  it "renders the edit operating_system form" do
    render

    assert_select "form[action=?][method=?]", operating_system_path(@operating_system), "post" do

      assert_select "input[name=?]", "operating_system[name]"

      assert_select "textarea[name=?]", "operating_system[matching_pattern]"
    end
  end
end
