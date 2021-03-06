require 'rails_helper'

RSpec.describe "software_raw_data/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software_raw_data" }
    allow(controller).to receive(:action_name) { "edit" }

    @software_raw_datum = assign(:software_raw_datum, SoftwareRawDatum.create!(
      software: nil,
      name: "MyString",
      version: "MyString",
      vendor: "MyString",
      count: 1,
      operating_system: "MyString",
      source: "MyString"
    ))
  end

  it "renders the edit software_raw_datum form" do
    render

    assert_select "form[action=?][method=?]", software_raw_datum_path(@software_raw_datum), "post" do

      assert_select "select[name=?]", "software_raw_datum[software_id]"
      assert_select "input[name=?]", "software_raw_datum[name]"
      assert_select "input[name=?]", "software_raw_datum[version]"
      assert_select "input[name=?]", "software_raw_datum[vendor]"
      assert_select "input[name=?]", "software_raw_datum[count]"
      assert_select "input[name=?]", "software_raw_datum[operating_system]"
      assert_select "input[name=?]", "software_raw_datum[lastseen]"
      assert_select "input[name=?]", "software_raw_datum[source]"
    end
  end
end
