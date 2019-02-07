require 'rails_helper'

RSpec.describe "mac_prefixes/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "mac_prefixes" }
    allow(controller).to receive(:action_name) { "edit" }

    @mac_prefix = assign(:mac_prefix, MacPrefix.create!(
      :oui => "112233",
      :vendor => "MyString"
    ))
  end

  it "renders the edit mac_prefix form" do
    render

    assert_select "form[action=?][method=?]", mac_prefix_path(@mac_prefix), "post" do
      assert_select "input[name=?]", "mac_prefix[oui]"
      assert_select "input[name=?]", "mac_prefix[vendor]"
    end
  end
end
