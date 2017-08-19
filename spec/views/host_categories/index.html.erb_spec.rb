require 'rails_helper'

RSpec.describe "host_categories/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "host_categories" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:host_categories, [
      HostCategory.create!(
        :name => "NewName1",
        :description => "MyText"
      ),
      HostCategory.create!(
        :name => "NewName2",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of host_categories" do
    render
    assert_select "tr>td", :text => "NewName1".to_s, :count => 1
    assert_select "tr>td", :text => "NewName2".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
