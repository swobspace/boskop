require 'rails_helper'

RSpec.describe "mac_prefixes/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "mac_prefixes" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:mac_prefix, MacPrefix.new(
      :oui => "112233",
      :vendor => "MyString"
    ))
  end

  it "renders new mac_prefix form" do
    render

    assert_select "form[action=?][method=?]", mac_prefixes_path, "post" do
      assert_select "input[name=?]", "mac_prefix[oui]"
      assert_select "input[name=?]", "mac_prefix[vendor]"
    end
  end
end
