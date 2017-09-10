require 'rails_helper'

RSpec.describe "operating_system_mappings/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "operating_system_mappings" }
    allow(controller).to receive(:action_name) { "edit" }

    os = FactoryGirl.create(:operating_system, name: "DummyOS")

    @operating_system_mapping = assign(:operating_system_mapping, OperatingSystemMapping.create!(
      :field => "Field",
      :value => "Value",
      :operating_system => os
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Field/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/DummyOS/)
  end
end
