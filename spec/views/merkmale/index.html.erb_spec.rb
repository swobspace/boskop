require 'rails_helper'

RSpec.describe "merkmale/index", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "merkmale" }
    allow(controller).to receive(:action_name) { "index" }

    @merkmalklasse = FactoryGirl.create(:merkmalklasse)
    @merkmalklass2 = FactoryGirl.create(:merkmalklasse)
    @location      = FactoryGirl.create(:location)
    assign(:merkmale, [
      Merkmal.create!(
        :merkmalfor => @location,
        :merkmalklasse => @merkmalklasse,
        :value => "Value"
      ),
      Merkmal.create!(
        :merkmalfor => @location,
        :merkmalklasse => @merkmalklass2,
        :value => "Value"
      )
    ])
  end

  it "renders a list of merkmale" do
    render
    assert_select "tr>td", :text => @merkmalklasse.to_s, :count => 1
    assert_select "tr>td", :text => @merkmalklass2.to_s, :count => 1
    assert_select "tr>td", :text => @location.to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
