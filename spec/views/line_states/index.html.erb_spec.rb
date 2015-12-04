require 'rails_helper'

RSpec.describe "line_states/index", type: :view do
  before(:each) do
    assign(:line_states, [
      LineState.create!(
        :name => "Name",
        :description => "MyText",
        :active => false
      ),
      LineState.create!(
        :name => "Name",
        :description => "MyText",
        :active => false
      )
    ])
  end

  it "renders a list of line_states" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
