require 'rails_helper'

RSpec.describe "framework_contracts/index", type: :view do
  before(:each) do
    assign(:framework_contracts, [
      FrameworkContract.create!(
        :name => "Name",
        :description => "MyText",
        :contract_period => 1,
        :period_of_notice => 2,
        :period_of_notice_unit => "Period Of Notice Unit",
        :renewal_period => 3,
        :renewal_unit => "Renewal Unit",
        :active => false
      ),
      FrameworkContract.create!(
        :name => "Name",
        :description => "MyText",
        :contract_period => 1,
        :period_of_notice => 2,
        :period_of_notice_unit => "Period Of Notice Unit",
        :renewal_period => 3,
        :renewal_unit => "Renewal Unit",
        :active => false
      )
    ])
  end

  it "renders a list of framework_contracts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Period Of Notice Unit".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Renewal Unit".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
