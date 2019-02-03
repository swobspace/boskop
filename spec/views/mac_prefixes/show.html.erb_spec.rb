require 'rails_helper'

RSpec.describe "mac_prefixes/show", type: :view do
  before(:each) do
    @mac_prefix = assign(:mac_prefix, MacPrefix.create!(
      :oui => "Oui",
      :vendor => "Vendor"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Oui/)
    expect(rendered).to match(/Vendor/)
  end
end
