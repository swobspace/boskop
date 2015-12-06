require 'rails_helper'

RSpec.describe "framework_contracts/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "framework_contracts" }
    allow(controller).to receive(:action_name) { "show" }

    @framework_contract = assign(:framework_contract, FrameworkContract.create!(
      :name => "Name",
      :description => "MyText",
      :contract_period => 1,
      :period_of_notice => 2,
      :period_of_notice_unit => "month",
      :renewal_period => 3,
      :renewal_unit => "year",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/month/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/year/)
    expect(rendered).to match(/false/)
  end
end
