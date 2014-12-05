require 'rails_helper'

RSpec.describe "networks/edit", :type => :view do
  before(:each) do
    @network = assign(:network, Network.create!(
      :location => nil,
      :netzwerk => "",
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit network form" do
    render

    assert_select "form[action=?][method=?]", network_path(@network), "post" do

      assert_select "input#network_location_id[name=?]", "network[location_id]"

      assert_select "input#network_netzwerk[name=?]", "network[netzwerk]"

      assert_select "input#network_name[name=?]", "network[name]"

      assert_select "textarea#network_description[name=?]", "network[description]"
    end
  end
end
