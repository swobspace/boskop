require 'rails_helper'

RSpec.describe "framework_contracts/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "framework_contracts" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:framework_contract, FrameworkContract.new(
      :name => "MyString",
      :description => "MyText",
      :contract_period => 1,
      :period_of_notice => 1,
      :period_of_notice_unit => "month",
      :renewal_period => 1,
      :renewal_unit => "month",
      :active => false
    ))
  end

  it "renders new framework_contract form" do
    render

    assert_select "form[action=?][method=?]", framework_contracts_path, "post" do

      assert_select "input#framework_contract_name[name=?]", "framework_contract[name]"

      assert_select "textarea#framework_contract_description[name=?]", "framework_contract[description]"

      assert_select "input#framework_contract_contract_period[name=?]", "framework_contract[contract_period]"

      assert_select "input#framework_contract_period_of_notice[name=?]", "framework_contract[period_of_notice]"

      assert_select "select#framework_contract_period_of_notice_unit[name=?]", "framework_contract[period_of_notice_unit]"

      assert_select "input#framework_contract_renewal_period[name=?]", "framework_contract[renewal_period]"

      assert_select "select#framework_contract_renewal_unit[name=?]", "framework_contract[renewal_unit]"

      assert_select "select#framework_contract_active[name=?]", "framework_contract[active]"
    end
  end
end
