require 'rails_helper'

RSpec.describe "merkmale/edit", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "merkmale" }
    allow(controller).to receive(:action_name) { "edit" }

    merkmalklasse = FactoryGirl.create(:merkmalklasse)
    location      = FactoryGirl.create(:location)
    @merkmal = assign(:merkmal, Merkmal.create!(
      :merkmalfor => location,
      :merkmalklasse => merkmalklasse,
      :value => "MyString"
    ))
  end

  it "renders the edit merkmal form" do
    render

    assert_select "form[action=?][method=?]", merkmal_path(@merkmal), "post" do
      assert_select "select#merkmal_merkmalklasse_id[name=?]", "merkmal[merkmalklasse_id]"
      assert_select "input#merkmal_value[name=?]", "merkmal[value]"
    end
  end
end
