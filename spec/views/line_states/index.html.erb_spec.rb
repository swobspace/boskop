require 'rails_helper'

RSpec.describe "line_states/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "line_states" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:line_states, [
      LineState.create!(
        :name => "Name1",
        :description => "MyText",
        :active => false
      ),
      LineState.create!(
        :name => "Name2",
        :description => "MyText",
        :active => false
      )
    ])
  end

  it "renders a list of line_states" do
    render
    assert_select "tr>td", :text => "Name1".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
