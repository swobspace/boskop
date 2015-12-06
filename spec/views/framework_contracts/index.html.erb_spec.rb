require 'rails_helper'

RSpec.describe "framework_contracts/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "framework_contracts" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:framework_contracts, [
      FrameworkContract.create!(
        :name => "Name1",
        :description => "MyText",
        :contract_period => 1,
        :period_of_notice => 2,
        :period_of_notice_unit => "month",
        :renewal_period => 3,
        :renewal_unit => "year",
        :active => false
      ),
      FrameworkContract.create!(
        :name => "Name2",
        :description => "MyText",
        :contract_period => 1,
        :period_of_notice => 2,
        :period_of_notice_unit => "month",
        :renewal_period => 3,
        :renewal_unit => "year",
        :active => false
      )
    ])
  end

  it "renders a list of framework_contracts" do
    render
    assert_select "tr>td", :text => "Name1".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "month".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "year".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
