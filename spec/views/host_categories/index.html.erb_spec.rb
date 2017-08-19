require 'rails_helper'

RSpec.describe "host_categories/index", type: :view do
  before(:each) do
    assign(:host_categories, [
      HostCategory.create!(
        :name => "Name",
        :description => "MyText"
      ),
      HostCategory.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of host_categories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
