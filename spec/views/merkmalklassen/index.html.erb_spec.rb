require 'rails_helper'

RSpec.describe "merkmalklassen/index", :type => :view do
  before(:each) do
    assign(:merkmalklassen, [
      Merkmalklasse.create!(
        :name => "Name",
        :description => "MyText",
        :format => "Format",
        :possible_values => "MyText"
      ),
      Merkmalklasse.create!(
        :name => "Name",
        :description => "MyText",
        :format => "Format",
        :possible_values => "MyText"
      )
    ])
  end

  it "renders a list of merkmalklassen" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Format".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
