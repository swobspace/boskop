require 'rails_helper'

RSpec.describe "merkmale/new", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "merkmale" }
    allow(controller).to receive(:action_name) { "edit" }

    merkmalklasse = FactoryGirl.create(:merkmalklasse)
    location      = FactoryGirl.create(:location)
    assign(:merkmal, Merkmal.new(
      :merkmalfor => location,
      :merkmalklasse => merkmalklasse,
      :value => "MyString"
    ))
  end

  it "renders new merkmal form" do
    render

    assert_select "form[action=?][method=?]", merkmale_path, "post" do
      assert_select "select#merkmal_merkmalklasse_id[name=?]", "merkmal[merkmalklasse_id]"
      assert_select "input#merkmal_value[name=?]", "merkmal[value]"
    end
  end
end
