require 'rails_helper'

RSpec.describe "locations/index", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "locations" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:locations, [
      Location.create!(
      :lid => 'TEST',
        :name => "Name01",
        :description => "Description",
        :position => 0
      ),
      Location.create!(
      :lid => 'TEST2',
        :name => "Name02",
        :description => "Description",
        :position => 0
      )
    ])
  end

  it "renders a list of locations" do
    render
    assert_select "tr>td", :text => "TEST".to_s, :count => 1
    assert_select "tr>td", :text => "TEST2".to_s, :count => 1
    assert_select "tr>td", :text => "Name01".to_s, :count => 1
    assert_select "tr>td", :text => "Name02".to_s, :count => 1
  end
end
