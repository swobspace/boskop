require 'rails_helper'

RSpec.describe "operating_systems/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "operating_system" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:operating_system, OperatingSystem.new(
      :name => "MyString",
      :matching_pattern => "MyText"
    ))
  end

  it "renders new operating_system form" do
    render

    assert_select "form[action=?][method=?]", operating_systems_path, "post" do

      assert_select "input[name=?]", "operating_system[name]"
      assert_select "input[name=?]", "operating_system[eol]"

      assert_select "textarea[name=?]", "operating_system[matching_pattern]"
    end
  end
end
