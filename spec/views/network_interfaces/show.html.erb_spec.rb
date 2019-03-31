require 'rails_helper'

RSpec.describe "network_interfaces/show", type: :view do
  before(:each) do
    @network_interface = assign(:network_interface, NetworkInterface.create!(
      :host => nil,
      :description => "Description",
      :ip => "",
      :mac => "Mac",
      :oui_vendor => "Oui Vendor"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Mac/)
    expect(rendered).to match(/Oui Vendor/)
  end
end
