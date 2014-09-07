require 'rails_helper'

RSpec.describe "locations/edit", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "locations" }
    allow(controller).to receive(:action_name) { "edit" }

    @location = assign(:location, Location.create!(
      :name => "MyString",
      :description => "MyString",
      :position => 1
    ))
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do

      assert_select "input#location_name[name=?]", "location[name]"
      assert_select "input#location_description[name=?]", "location[description]"
      assert_select "input#location_position[name=?]", "location[position]"
    end
  end
end
