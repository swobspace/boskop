require 'rails_helper'

RSpec.describe "hosts/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "hosts" }
    allow(controller).to receive(:action_name) { "show" }

    location = FactoryGirl.create(:location, lid: "LID")
    hostcategory = FactoryGirl.create(:host_category, name: "SecureServer")

    @host = assign(:host, FactoryGirl.create(:host,
      :name => "MyLovelyHost",
      :description => "Runningforever",
      :ip => "192.168.77.79",
      :cpe => "cpe:/o:microsoft:windows_7::sp1:professional",
      :raw_os => "Windows 7 Professional 6.1",
      :mac => "MAC",
      :fqdn => "MyLovelyHost.example.net",
      :domain_dns => "example.net",
      :workgroup => "Workgroup3",
      :host_category => hostcategory,
      :location => location
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
    expect(rendered).to match(/MyLovelyHost.example.net/)
    expect(rendered).to match(/example.net/)
    expect(rendered).to match(/Workgroup3/)
    expect(rendered).to match(/LID/)
    expect(rendered).to match(/SecureServer/)
  end
end
