require 'rails_helper'

RSpec.describe "network_interfaces/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "mac_prefixes" }
    allow(controller).to receive(:action_name) { "edit" }

    host = FactoryBot.create(:host, name: 'myName', serial: 'ABCDEFG', uuid: '9f60214e-ac06-4f66-b2ae-ad4ffba02826')
    @network_interface = assign(:network_interface, FactoryBot.create(:network_interface,
      :host => host,
      :description => "Description",
      :ip => '192.0.2.77',
      :mac => "00-11-22-33-44-55",
    ))
    expect(host).to receive(:lid).and_return("LID")
    expect(@network_interface).to receive(:oui_vendor).and_return("Oui Vendor")
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/LID/)
    expect(rendered).to match(/myName/)
    expect(rendered).to match(/ABCDEFG/)
    expect(rendered).to match(/9f60214e-ac06-4f66-b2ae-ad4ffba02826/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/192.0.2.77/)
    expect(rendered).to match(/001122334455/)
    expect(rendered).to match(/Oui Vendor/)
  end
end
