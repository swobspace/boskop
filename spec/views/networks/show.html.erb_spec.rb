require 'rails_helper'

RSpec.describe "networks/show", :type => :view do
  before(:each) do
    @network = assign(:network, Network.create!(
      :location => nil,
      :netzwerk => "",
      :name => "Name",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
