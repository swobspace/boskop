require 'rails_helper'

RSpec.describe "vulnerabilities/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "vulnerability" }
    allow(controller).to receive(:action_name) { "show" }

    host = FactoryGirl.create(:host, ip: '192.81.51.117', name: 'vxserver')
    @vulnerability = assign(:vulnerability, Vulnerability.create!(
      :host => host,
      :lastseen => 1.day.before(Date.today),
      :vulnerability_detail => FactoryGirl.create(:vulnerability_detail,
                                 name: "Hackable by Kids")
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/192.81.51.117 \(vxserver\)/)
    expect(rendered).to match(/Hackable by Kids/)
    expect(rendered).to match(/#{1.day.before(Date.today).to_s}/)
  end
end
