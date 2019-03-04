require 'rails_helper'

RSpec.describe "mac_prefixes/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "mac_prefixes" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:mac_prefixes, [
      MacPrefix.create!(
        :oui => "112233",
        :vendor => "Vendor"
      ),
      MacPrefix.create!(
        :oui => "112244",
        :vendor => "Vendor"
      )
    ])
  end

  it "renders a list of mac_prefixes" do
    render
    assert_select "tr>td", :text => "112233".to_s, :count => 1
    assert_select "tr>td", :text => "112244".to_s, :count => 1
    assert_select "tr>td", :text => "Vendor".to_s, :count => 2
  end
end
