require 'rails_helper'

RSpec.describe "mac_prefixes/index", type: :view do
  before(:each) do
    assign(:mac_prefixes, [
      MacPrefix.create!(
        :oui => "Oui",
        :vendor => "Vendor"
      ),
      MacPrefix.create!(
        :oui => "Oui",
        :vendor => "Vendor"
      )
    ])
  end

  it "renders a list of mac_prefixes" do
    render
    assert_select "tr>td", :text => "Oui".to_s, :count => 2
    assert_select "tr>td", :text => "Vendor".to_s, :count => 2
  end
end
