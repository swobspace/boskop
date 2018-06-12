require 'rails_helper'

RSpec.describe "operating_systems/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "operating_system" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:operating_systems, [
      OperatingSystem.create!(
        :name => "Name1",
      ),
      OperatingSystem.create!(
        :name => "Name2",
        :eol => "2014-04-08",
        :matching_pattern => "MyText"
      )
    ])
  end

  it "renders a list of operating_systems" do
    render
    assert_select "tr>td", :text => "Name1".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 1
    assert_select "tr>td", :text => "2014-04-08".to_s, :count => 1
  end
end
