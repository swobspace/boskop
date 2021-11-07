require 'rails_helper'

RSpec.describe "networks/search_form", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "networks" }
    allow(controller).to receive(:action_name) { "search" }

    @merkmalklassen = []
  end

  it "renders the search network form" do
    render

    assert_select "form[action=?][method=?]", search_networks_path, "post" do
      assert_select "input#netzwerk[name=?]", "netzwerk"
      assert_select "input#ort[name=?]", "ort"
      assert_select "input#description[name=?]", "description"
      assert_select "input#lid[name=?]", "lid"
      assert_select "input#is_subset[name=?]", "is_subset"
      assert_select "input#is_superset[name=?]", "is_superset"
    end
  end
end
