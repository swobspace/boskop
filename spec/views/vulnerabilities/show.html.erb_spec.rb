require 'rails_helper'

RSpec.describe "vulnerabilities/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "vulnerability" }
    allow(controller).to receive(:action_name) { "show" }

    host = FactoryBot.create(:host, name: 'vxserver',
                             network_interfaces_attributes: [
                               { ip: '192.81.51.117', lastseen: Date.today }
                             ])
    @vulnerability = assign(:vulnerability, Vulnerability.create!(
      :host => host,
      :lastseen => 1.day.before(Date.today),
      :vulnerability_detail => FactoryBot.create(:vulnerability_detail,
                                 name: "Hackable by Kids",
                                 severity: "10.0",
                                 threat: "high",
                               )
    ))
    allow(host).to receive(:lid).and_return("XYZ")
    allow(host).to receive(:operating_system).and_return("Nonux")
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/192.81.51.117 \(vxserver\)/)
    expect(rendered).to match(/Hackable by Kids/)
    expect(rendered).to match(/#{1.day.before(Date.today).to_s}/)
    expect(rendered).to match(/10.0/)
    expect(rendered).to match(/high/)
    expect(rendered).to match(/Nonux/)
    expect(rendered).to match(/XYZ/)
  end
end
