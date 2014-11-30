require 'rails_helper'

RSpec.describe "org_units/index", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "org_units" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:org_units, [
      OrgUnit.create!(
        :name => "Name01",
        :description => "Description",
        :position => 2
      ),
      OrgUnit.create!(
        :name => "Name02",
        :description => "Description",
        :position => 2
      )
    ])
  end

  it "renders a list of org_units" do
    render
    assert_select "tr>td", :text => "Name01".to_s, :count => 1
    assert_select "tr>td", :text => "Name02".to_s, :count => 1
  end
end
