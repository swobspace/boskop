require 'rails_helper'

RSpec.describe "addresses/index", :type => :view do
  before(:each) do
    assign(:addresses, [
      Address.create!(
        :addressfor => nil,
        :streetaddress => "Streetaddress",
        :plz => "Plz",
        :ort => "Ort",
        :care_of => "Care Of",
        :postfach => "Postfach",
        :postfachplz => "Postfachplz"
      ),
      Address.create!(
        :addressfor => nil,
        :streetaddress => "Streetaddress",
        :plz => "Plz",
        :ort => "Ort",
        :care_of => "Care Of",
        :postfach => "Postfach",
        :postfachplz => "Postfachplz"
      )
    ])
  end

  it "renders a list of addresses" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Streetaddress".to_s, :count => 2
    assert_select "tr>td", :text => "Plz".to_s, :count => 2
    assert_select "tr>td", :text => "Ort".to_s, :count => 2
    assert_select "tr>td", :text => "Care Of".to_s, :count => 2
    assert_select "tr>td", :text => "Postfach".to_s, :count => 2
    assert_select "tr>td", :text => "Postfachplz".to_s, :count => 2
  end
end
