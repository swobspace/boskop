require 'rails_helper'

RSpec.describe "hosts/search", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "hosts" }
    allow(controller).to receive(:action_name) { "search" }

    location = FactoryBot.create(:location, lid: "LID")
    hostcategory = FactoryBot.create(:host_category, name: "SecureServer")
    os = FactoryBot.create(:operating_system, name: 'ZementOS')
    macprefix = FactoryBot.create(:mac_prefix, oui: '001122', vendor: "Granite C.")

    assign(:hosts, [
      FactoryBot.create(:host,
        :name => "MyLovelyHost",
        :description => "Runningforever",
        :cpe => "cpe:/o:microsoft:windows_7::sp1:professional",
        :raw_os => "Windows 7 Professional 6.1",
        :serial => "XXX7785T",
        :uuid => "31eb2a81-2fc6-4be8-815d-543fe9ce9fd7",
        :fqdn => "MyLovelyHost.example.net",
        :vendor => "Tuxolino",
        :product => "TuxStation",
        :warranty_sla => "2 years bring in",
        :warranty_start => "2017-03-01",
        :warranty_end => "2019-02-28",
        :domain_dns => "example.net",
        :workgroup => "Workgroup3",
        :host_category => hostcategory,
        :operating_system => os,
        :vuln_risk => 'High',
        :network_interfaces_attributes => [
          {ip: '192.168.81.82', mac: '00:11:22:33:44:55', lastseen: Date.today}
        ],
        :location => location),
      FactoryBot.create(:host,
        :name => "MyLovelyHost",
        :description => "Runningforever",
        :cpe => "cpe:/o:microsoft:windows_7::sp1:professional",
        :raw_os => "Windows 7 Professional 6.1",
        :serial => "XXX7785T",
        :vendor => "Tuxolino",
        :product => "TuxStation",
        :warranty_sla => "2 years bring in",
        :warranty_start => "2017-03-01",
        :warranty_end => "2019-02-28",
        :fqdn => "MyLovelyHost.example.net",
        :domain_dns => "example.net",
        :workgroup => "Workgroup3",
        :host_category => hostcategory,
        :operating_system => os,
        :vuln_risk => 'High',
        :network_interfaces_attributes => [
          {ip: '192.168.83.84', mac: '00:11:22:33:44:55', lastseen: Date.today}
        ],
        :location => location)
    ])
  end

  it "renders a list of hosts" do
    render
    puts rendered
    assert_select "tr>td", :text => "MyLovelyHost".to_s, :count => 2
    assert_select "tr>td", :text => "Runningforever".to_s, :count => 2
    assert_select "tr>td", :text => "192.168.81.82".to_s, :count => 1
    assert_select "tr>td", :text => "192.168.83.84".to_s, :count => 1
    assert_select "tr>td", :text => "cpe:/o:microsoft:windows_7::sp1:professional".to_s, :count => 2
    assert_select "tr>td", :text => "Windows 7 Professional 6.1".to_s, :count => 2
    assert_select "tr>td", :text => "001122334455".to_s, :count => 2
    assert_select "tr>td", :text => "Granite C.".to_s, :count => 2
    assert_select "tr>td", :text => "XXX7785T".to_s, :count => 2
    assert_select "tr>td", :text => "31eb2a81-2fc6-4be8-815d-543fe9ce9fd7".to_s, :count => 1
    assert_select "tr>td", :text => "Tuxolino".to_s, :count => 2
    assert_select "tr>td", :text => "TuxStation".to_s, :count => 2
    assert_select "tr>td", :text => "2 years bring in".to_s, :count => 2
    assert_select "tr>td", :text => "2017-03-01".to_s, :count => 2
    assert_select "tr>td", :text => "2019-02-28".to_s, :count => 2
    assert_select "tr>td", :text => "ZementOS".to_s, :count => 2
    assert_select "tr>td", :text => "MyLovelyHost.example.net".to_s, :count => 2
    assert_select "tr>td", :text => "example.net".to_s, :count => 2
    assert_select "tr>td", :text => "Workgroup3".to_s, :count => 2
    assert_select "tr>td", :text => "LID".to_s, :count => 2
    assert_select "tr>td", :text => "SecureServer".to_s, :count => 2
    assert_select "tr>td", :text => "High".to_s, :count => 2
  end
end
