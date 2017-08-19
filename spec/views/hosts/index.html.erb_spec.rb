require 'rails_helper'

RSpec.describe "hosts/index", type: :view do
  before(:each) do
    assign(:hosts, [
      Host.create!(
        :name => "Name",
        :description => "MyText",
        :ip => "",
        :cpe => "Cpe",
        :lanmanager => "Lanmanager",
        :operating_system => nil,
        :mac => "Mac",
        :host_category => nil,
        :location => nil
      ),
      Host.create!(
        :name => "Name",
        :description => "MyText",
        :ip => "",
        :cpe => "Cpe",
        :lanmanager => "Lanmanager",
        :operating_system => nil,
        :mac => "Mac",
        :host_category => nil,
        :location => nil
      )
    ])
  end

  it "renders a list of hosts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Cpe".to_s, :count => 2
    assert_select "tr>td", :text => "Lanmanager".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Mac".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
