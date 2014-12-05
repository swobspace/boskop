require 'rails_helper'

RSpec.describe "networks/index", :type => :view do
  before(:each) do
    assign(:networks, [
      Network.create!(
        :location => nil,
        :netzwerk => "",
        :name => "Name",
        :description => "MyText"
      ),
      Network.create!(
        :location => nil,
        :netzwerk => "",
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of networks" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
