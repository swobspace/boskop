require 'rails_helper'

RSpec.describe "access_types/index", type: :view do
  before(:each) do
    assign(:access_types, [
      AccessType.create!(
        :name => "Name",
        :description => "MyText"
      ),
      AccessType.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of access_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
