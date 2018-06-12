require 'rails_helper'

RSpec.describe "operating_systems/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "operating_system" }
    allow(controller).to receive(:action_name) { "show" }

    @operating_system = assign(:operating_system, OperatingSystem.create!(
      :name => "Name",
      :eol => '2014-04-08',
      :matching_pattern => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2014-04-08/)
  end

  it "renders os without name and matching pattern" do
    @operating_system.update_attributes(eol: nil, matching_pattern: nil)
    render
    expect(rendered).to match(/#{@operating_system.name}/)
    
  end
end
