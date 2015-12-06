require 'rails_helper'

RSpec.describe "access_types/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "access_types" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:access_types, [
      AccessType.create!(
        :name => "Name1",
        :description => "MyText"
      ),
      AccessType.create!(
        :name => "Name2",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of access_types" do
    render
    assert_select "tr>td", :text => "Name1".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
