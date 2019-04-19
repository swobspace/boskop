require 'rails_helper'

RSpec.describe HostConcerns, type: :model do
  let(:loc1)   { FactoryBot.create(:location, lid: 'ABC') }
  let(:loc2)   { FactoryBot.create(:location, lid: 'XYZ') }

  let!(:host1) { FactoryBot.create(:host, location: loc1)}
  let!(:host2) { FactoryBot.create(:host, location: loc1)}
  let!(:host3) { FactoryBot.create(:host, location: loc2)}
  let!(:host4) { FactoryBot.create(:host)}
  let!(:host5) { FactoryBot.create(:host, lastseen: 5.weeks.before(Date.today))}
  let!(:host6) { FactoryBot.create(:host, location: loc2)}
  let!(:host7) { FactoryBot.create(:host, location: loc2)}
  let(:h)  { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.3)}
  let(:h2) { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.0)}
  let(:m) { FactoryBot.create(:vulnerability_detail, threat: 'Medium', severity: 5.0)}
  let(:l) { FactoryBot.create(:vulnerability_detail, threat: 'Low', severity: 2.1)}
  let(:c) { FactoryBot.create(:vulnerability_detail, threat: 'Critical', severity: 10.0)}  

  let!(:v1h) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: h)}
  let!(:v1h2) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: h)}
  let!(:v1m) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: m)}
  let!(:v1c) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: c)}

  let!(:v2h) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: h)}
  let!(:v2h2) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: h)}
  let!(:v2m) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: m)}
  let!(:v2l) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: l)}

  let!(:v3m) { FactoryBot.create(:vulnerability, host: host3, vulnerability_detail: m)}
  let!(:v3l) { FactoryBot.create(:vulnerability, host: host3, vulnerability_detail: l)}

  let!(:v4l) { FactoryBot.create(:vulnerability, host: host4, vulnerability_detail: l)}

  let!(:v5l) { FactoryBot.create(:vulnerability, host: host4, vulnerability_detail: l,
                                 lastseen: 5.weeks.before(Date.today))}

  let!(:v6m) { FactoryBot.create(:vulnerability, host: host6, vulnerability_detail: m)}

  describe "::vuln_risk_matrix" do
    before(:each) do 
      UpdateVulnRiskJob.perform_now
    end

    it "generates vuln risk matrix" do
      expect(Host.vuln_risk_matrix).to contain_exactly(
        {risk: "Critical", lid: "ABC", count: 1},
        {risk: "High", lid: "ABC", count: 1},
        {risk: "Medium", lid: "XYZ", count: 2},
        {risk: "Low", lid: nil, count: 1},
        {risk: "None", lid: "XYZ", count: 1},
      )
    end
  end

  describe "::to_csv" do
    let!(:mklasse) { FactoryBot.create(:merkmalklasse, for_object: 'Host', 
                                       name: 'Verantwortlich', tag: 'responsible') }
    let(:location) { FactoryBot.create(:location, lid: "LID") }
    let(:hostcategory) { FactoryBot.create(:host_category, name: "Secure Server") }
    let(:os) { FactoryBot.create(:operating_system, name: "ZementOS") }
    let!(:iface) { FactoryBot.create(:network_interface,
      :host_id => host.id,
      :lastseen => Date.today,
      :ip => "192.168.77.79",
      :mac => "11:22:33:44:55:66",
    )}
      
    let(:host) { FactoryBot.create(:host,
      :name => "MyLovelyHost",
      :description => "Runningforever",
      :cpe => "cpe:/o:microsoft:windows_7::sp1:professional",
      :raw_os => "Windows 7 Professional 6.1",
      :vendor => "Tuxolino",
      :fqdn => "MyLovelyHost.example.net",
      :domain_dns => "example.net",
      :workgroup => "Workgroup3",
      :host_category => hostcategory,
      :operating_system => os,
      :location => location,
      :vuln_risk => 'High',
      :lastseen => Date.today,
      :merkmal_responsible => "Mr. Superadmin"
    )}

    it "renders csv" do
      hosts = [host]
      csv = CSV.parse(Host.to_csv)
      expect(csv.shift).to contain_exactly(
                I18n.t('attributes.name'),
                I18n.t('attributes.description'),
                I18n.t('attributes.ip'),
                I18n.t('attributes.operating_system'),
                I18n.t('attributes.cpe'),
                I18n.t('attributes.raw_os'),
                I18n.t('attributes.fqdn'),
                I18n.t('attributes.domain_dns'),
                I18n.t('attributes.workgroup'),
                I18n.t('attributes.lastseen'),
                I18n.t('attributes.vuln_risk'),
                I18n.t('attributes.mac'),
                I18n.t('attributes.vendor'),
                I18n.t('attributes.host_category'),
                I18n.t('attributes.location'),
                "Verantwortlich"
              )
      expect(csv.last).to contain_exactly(
      "MyLovelyHost", "Runningforever", "192.168.77.79",
      "cpe:/o:microsoft:windows_7::sp1:professional",
      "Windows 7 Professional 6.1", "112233445566", "Tuxolino",
      "MyLovelyHost.example.net", "example.net", "Workgroup3",
      "Secure Server", "ZementOS", "LID", 'High', Date.today.to_s, "Mr. Superadmin")
    end
  end
end
