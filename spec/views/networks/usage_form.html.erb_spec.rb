require 'rails_helper'

RSpec.describe "networks/usage_form", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "networks" }
    allow(controller).to receive(:action_name) { "usage_form" }

  end

  it "renders the usage_form network form" do
    render

    assert_select "form[action=?][method=?]", usage_networks_path, "post" do
      assert_select "input#cidr[name=?]", "cidr"
      assert_select "input#mask[name=?]", "mask"
      assert_select "input#exact_match[name=?]", "exact_match"
    end
  end
end
