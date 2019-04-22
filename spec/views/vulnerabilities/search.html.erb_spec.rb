require 'rails_helper'

RSpec.describe "vulnerabilities/search", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "vulnerability" }
    allow(controller).to receive(:action_name) { "search" }

    hostcat = FactoryBot.create(:host_category, name: 'Server')
    host = FactoryBot.create(:host, name: 'vxserver', host_category: hostcat,
                             network_interfaces_attributes: [
                               { ip: '192.81.51.117', lastseen: Date.today }
                             ]
                             )
    assign(:vulnerabilities, [
      Vulnerability.create!(
        :host => host,
        :lastseen => 1.day.before(Date.today),
        :vulnerability_detail => FactoryBot.create(:vulnerability_detail,
                                   name: "End-of-Life", 
                                   severity: "10.0",
                                   threat: "high",
                                 )
      ),
      Vulnerability.create!(
        :host => host,
        :lastseen => 1.day.before(Date.today),
        :vulnerability_detail => FactoryBot.create(:vulnerability_detail,
                                   name: "Hackable by Kids",
                                   severity: "8.7",
                                   threat: "high",
                                 )
      )
    ])
    allow(host).to receive(:lid).and_return("XYZ")
    allow(host).to receive(:operating_system).and_return("Nonux")
  end

  it "renders a list of vulnerabilities" do
    render
    assert_select "tr>td", :text => "XYZ".to_s, :count => 2
    assert_select "tr>td", :text => "192.81.51.117".to_s, :count => 2
    assert_select "tr>td", :text => "vxserver", :count => 2
    assert_select "tr>td", :text => "Server", :count => 2
    assert_select "tr>td", :text => "End-of-Life".to_s, :count => 1
    assert_select "tr>td", :text => "Hackable by Kids".to_s, :count => 1
    assert_select "tr>td", :text => 1.day.before(Date.today).to_s, :count => 2
    assert_select "tr>td", :text => "high", :count => 2
    assert_select "tr>td", :text => "10.0", :count => 1
    assert_select "tr>td", :text => "8.7", :count => 1
    assert_select "tr>td", :text => "Nonux", :count => 2
  end
end
