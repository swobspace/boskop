require 'rails_helper'

RSpec.describe "framework_contracts/show", type: :view do
  before(:each) do
    @framework_contract = assign(:framework_contract, FrameworkContract.create!(
      :name => "Name",
      :description => "MyText",
      :contract_period => 1,
      :period_of_notice => 2,
      :period_of_notice_unit => "Period Of Notice Unit",
      :renewal_period => 3,
      :renewal_unit => "Renewal Unit",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Period Of Notice Unit/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Renewal Unit/)
    expect(rendered).to match(/false/)
  end
end
