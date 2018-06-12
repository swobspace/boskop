require 'rails_helper'

RSpec.describe "addresses/index", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "addresses" }
    allow(controller).to receive(:action_name) { "index" }

    @location      = FactoryBot.create(:location)

    assign(:addresses, [
      Address.create!(
        :addressfor => @location,
        :streetaddress => "Streetaddress",
        :plz => "123456",
        :ort => "Ort",
        :care_of => "Care Of",
        :postfach => "Postfach",
        :postfachplz => "Postfachplz"
      ),
      Address.create!(
        :addressfor => @location,
        :streetaddress => "Streetaddress",
        :plz => "123456",
        :ort => "Ort",
        :care_of => "Care Of",
        :postfach => "Postfach",
        :postfachplz => "Postfachplz"
      )
    ])
  end

  it "renders a list of addresses" do
    render
    assert_select "tr>td", :text => @location.to_s, :count => 2
    assert_select "tr>td", :text => "Streetaddress".to_s, :count => 2
    assert_select "tr>td", :text => "123456".to_s, :count => 2
    assert_select "tr>td", :text => "Ort".to_s, :count => 2
    assert_select "tr>td", :text => "Care Of".to_s, :count => 2
    assert_select "tr>td", :text => "Postfach".to_s, :count => 2
    assert_select "tr>td", :text => "Postfachplz".to_s, :count => 2
  end
end
