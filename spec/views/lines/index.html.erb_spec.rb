require 'rails_helper'

RSpec.describe "lines/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "lines" }
    allow(controller).to receive(:action_name) { "edit" }

    assign(:lines, [
      Line.create!(
        :name => "Name",
        :description => "MyText",
        :provider_id => "Provider",
        :location_a_id => 1,
        :location_b_id => 2,
        :access_type => nil,
        :bw_upstream => "9.99",
        :bw_downstream => "9.99",
        :framework_contract => nil,
        :contract_period => 3,
        :period_of_notice => 4,
        :period_of_notice_unit => "Period Of Notice Unit",
        :renewal_period => 5,
        :renewal_unit => "Renewal Unit",
        :line_state => nil
      ),
      Line.create!(
        :name => "Name",
        :description => "MyText",
        :provider_id => "Provider",
        :location_a_id => 1,
        :location_b_id => 2,
        :access_type => nil,
        :bw_upstream => "9.99",
        :bw_downstream => "9.99",
        :framework_contract => nil,
        :contract_period => 3,
        :period_of_notice => 4,
        :period_of_notice_unit => "Period Of Notice Unit",
        :renewal_period => 5,
        :renewal_unit => "Renewal Unit",
        :line_state => nil
      )
    ])
  end

  it "renders a list of lines" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Provider".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Period Of Notice Unit".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Renewal Unit".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
