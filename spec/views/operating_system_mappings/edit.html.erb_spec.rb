require 'rails_helper'

RSpec.describe "operating_system_mappings/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "operating_system_mappings" }
    allow(controller).to receive(:action_name) { "edit" }

    @operating_system_mapping = assign(:operating_system_mapping, OperatingSystemMapping.create!(
      :field => "MyField",
      :value => "MyString",
      :operating_system => nil
    ))
  end

  it "renders the edit operating_system_mapping form" do
    render

    assert_select "form[action=?][method=?]", operating_system_mapping_path(@operating_system_mapping), "post" do

      assert_select "input[name=?]", "operating_system_mapping[field]"

      assert_select "input[name=?]", "operating_system_mapping[value]"

      assert_select "select[name=?]", "operating_system_mapping[operating_system_id]"
    end
  end
end
