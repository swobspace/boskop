require 'rails_helper'

RSpec.describe "network_interfaces/index", type: :view do
  before(:each) do
    assign(:network_interfaces, [
      NetworkInterface.create!(
        :host => nil,
        :description => "Description",
        :ip => "",
        :mac => "Mac",
        :oui_vendor => "Oui Vendor"
      ),
      NetworkInterface.create!(
        :host => nil,
        :description => "Description",
        :ip => "",
        :mac => "Mac",
        :oui_vendor => "Oui Vendor"
      )
    ])
  end

  it "renders a list of network_interfaces" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Mac".to_s, :count => 2
    assert_select "tr>td", :text => "Oui Vendor".to_s, :count => 2
  end
end
