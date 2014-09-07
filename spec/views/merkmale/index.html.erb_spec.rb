require 'rails_helper'

RSpec.describe "merkmale/index", :type => :view do
  before(:each) do
    assign(:merkmale, [
      Merkmal.create!(
        :merkmalfor => nil,
        :merkmalklasse => nil,
        :value => "Value"
      ),
      Merkmal.create!(
        :merkmalfor => nil,
        :merkmalklasse => nil,
        :value => "Value"
      )
    ])
  end

  it "renders a list of merkmale" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
