require 'rails_helper'

RSpec.describe "org_units/index", :type => :view do
  before(:each) do
    assign(:org_units, [
      OrgUnit.create!(
        :name => "Name",
        :description => "Description",
        :ancestry => "Ancestry",
        :ancestry_depth => 1,
        :position => 2
      ),
      OrgUnit.create!(
        :name => "Name",
        :description => "Description",
        :ancestry => "Ancestry",
        :ancestry_depth => 1,
        :position => 2
      )
    ])
  end

  it "renders a list of org_units" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Ancestry".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
