require 'rails_helper'

RSpec.describe "lines/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "lines" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:line, Line.new(
      :name => "MyString",
      :description => "MyText",
      :provider_id => "MyString",
      :location_a_id => 1,
      :location_b_id => 1,
      :access_type_id => 1,
      :bw_upstream => "9.99",
      :bw_downstream => "9.99",
      :framework_contract => nil,
      :contract_period => 1,
      :period_of_notice => 3,
      :period_of_notice_unit => "month",
      :renewal_period => 1,
      :renewal_unit => "year",
      :line_state_id => 1
    ))
  end

  it "renders new line form" do
    render

    assert_select "form[action=?][method=?]", lines_path, "post" do

      assert_select "input#line_name[name=?]", "line[name]"

      assert_select "textarea#line_description[name=?]", "line[description]"

      assert_select "input#line_provider_id[name=?]", "line[provider_id]"

      assert_select "select#line_location_a_id[name=?]", "line[location_a_id]"

      assert_select "select#line_location_b_id[name=?]", "line[location_b_id]"

      assert_select "select#line_access_type_id[name=?]", "line[access_type_id]"

      assert_select "input#line_bw_upstream[name=?]", "line[bw_upstream]"

      assert_select "input#line_bw_downstream[name=?]", "line[bw_downstream]"

      assert_select "select#line_framework_contract_id[name=?]", "line[framework_contract_id]"

      assert_select "input#line_contract_period[name=?]", "line[contract_period]"

      assert_select "input#line_period_of_notice[name=?]", "line[period_of_notice]"

      assert_select "select#line_period_of_notice_unit[name=?]", "line[period_of_notice_unit]"

      assert_select "input#line_renewal_period[name=?]", "line[renewal_period]"

      assert_select "select#line_renewal_unit[name=?]", "line[renewal_unit]"

      assert_select "select#line_line_state_id[name=?]", "line[line_state_id]"
    end
  end
end
