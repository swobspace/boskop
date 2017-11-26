require 'rails_helper'

RSpec.describe "operating_system_mappings/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "operating_system_mappings" }
    allow(controller).to receive(:action_name) { "index" }

    os = FactoryBot.create(:operating_system, name: 'DummyOS' )

    assign(:operating_system_mappings, [
      OperatingSystemMapping.create!(
        :field => "Field",
        :value => "Value",
        :operating_system => os
      ),
      OperatingSystemMapping.create!(
        :field => "Field",
        :value => "Value",
        :operating_system => os
      )
    ])
  end

  it "renders a list of operating_system_mappings" do
    render
    assert_select "tr>td", :text => "Field".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    assert_select "tr>td", :text => "DummyOS".to_s, :count => 2
  end
end
