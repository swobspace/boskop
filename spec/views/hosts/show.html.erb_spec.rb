require 'rails_helper'

RSpec.describe "hosts/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "hosts" }
    allow(controller).to receive(:action_name) { "show" }

    location = FactoryBot.create(:location, lid: "LID")
    hostcategory = FactoryBot.create(:host_category, name: "SecureServer")
    os = FactoryBot.create(:operating_system, name: "ZementOS")

    @host = assign(:host, FactoryBot.create(:host,
      :name => "MyLovelyHost",
      :description => "Runningforever",
      :ip => "192.168.77.79",
      :cpe => "cpe:/o:microsoft:windows_7::sp1:professional",
      :raw_os => "Windows 7 Professional 6.1",
      :mac => "MAC",
      :serial => "XXX7785T",
      :vendor => "Tuxolino",
      :fqdn => "MyLovelyHost.example.net",
      :domain_dns => "example.net",
      :workgroup => "Workgroup3",
      :host_category => hostcategory,
      :operating_system => os,
      :location => location,
      :vuln_risk => 'High'
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyLovelyHost/)
    expect(rendered).to match(/Runningforever/)
    expect(rendered).to match(/192.168.77.79/)
    expect(rendered).to match("cpe:/o:microsoft:windows_7::sp1:professional")
    expect(rendered).to match(/Windows 7 Professional 6.1/)
    expect(rendered).to match(/MAC/)
    expect(rendered).to match(/XXX7785T/)
    expect(rendered).to match(/Tuxolino/)
    expect(rendered).to match(/ZementOS/)
    expect(rendered).to match(/MyLovelyHost.example.net/)
    expect(rendered).to match(/example.net/)
    expect(rendered).to match(/Workgroup3/)
    expect(rendered).to match(/LID/)
    expect(rendered).to match(/SecureServer/)
    expect(rendered).to match(/High/)
  end
end
