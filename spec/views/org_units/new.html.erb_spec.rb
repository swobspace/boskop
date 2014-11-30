require 'rails_helper'

RSpec.describe "org_units/new", :type => :view do
  before(:each) do
    assign(:org_unit, OrgUnit.new(
      :name => "MyString",
      :description => "MyString",
      :ancestry => "MyString",
      :ancestry_depth => 1,
      :position => 1
    ))
  end

  it "renders new org_unit form" do
    render

    assert_select "form[action=?][method=?]", org_units_path, "post" do

      assert_select "input#org_unit_name[name=?]", "org_unit[name]"

      assert_select "input#org_unit_description[name=?]", "org_unit[description]"

      assert_select "input#org_unit_ancestry[name=?]", "org_unit[ancestry]"

      assert_select "input#org_unit_ancestry_depth[name=?]", "org_unit[ancestry_depth]"

      assert_select "input#org_unit_position[name=?]", "org_unit[position]"
    end
  end
end
