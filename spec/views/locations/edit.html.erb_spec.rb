require 'rails_helper'

RSpec.describe "locations/edit", :type => :view do
  before(:each) do
    @location = assign(:location, Location.create!(
      :name => "MyString",
      :description => "MyString",
      :ancestry => "MyString",
      :ancestry_depth => 1,
      :position => 1
    ))
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do

      assert_select "input#location_name[name=?]", "location[name]"

      assert_select "input#location_description[name=?]", "location[description]"

      assert_select "input#location_ancestry[name=?]", "location[ancestry]"

      assert_select "input#location_ancestry_depth[name=?]", "location[ancestry_depth]"

      assert_select "input#location_position[name=?]", "location[position]"
    end
  end
end
