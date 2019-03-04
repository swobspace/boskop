require 'rails_helper'

RSpec.describe "mac_prefixes/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "mac_prefixes" }
    allow(controller).to receive(:action_name) { "show" }

    @mac_prefix = assign(:mac_prefix, MacPrefix.create!(
      :oui => "112233",
      :vendor => "Vendor"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/112233/)
    expect(rendered).to match(/Vendor/)
  end
end
