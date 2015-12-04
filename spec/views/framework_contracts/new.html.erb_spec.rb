require 'rails_helper'

RSpec.describe "framework_contracts/new", type: :view do
  before(:each) do
    assign(:framework_contract, FrameworkContract.new(
      :name => "MyString",
      :description => "MyText",
      :contract_period => 1,
      :period_of_notice => 1,
      :period_of_notice_unit => "MyString",
      :renewal_period => 1,
      :renewal_unit => "MyString",
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

      assert_select "input#framework_contract_period_of_notice_unit[name=?]", "framework_contract[period_of_notice_unit]"

      assert_select "input#framework_contract_renewal_period[name=?]", "framework_contract[renewal_period]"

      assert_select "input#framework_contract_renewal_unit[name=?]", "framework_contract[renewal_unit]"

      assert_select "input#framework_contract_active[name=?]", "framework_contract[active]"
    end
  end
end
