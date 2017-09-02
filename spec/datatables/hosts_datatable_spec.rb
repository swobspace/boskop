require 'rails_helper'

module HostsDatatableHelper
  def host2array(host)
    [].tap do |column|
      column << host.name
      column << host.description
      column << host.ip.to_s
      column << host.cpe
      column << host.raw_os
      column << host.fqdn
      column << host.domain_dns
      column << host.workgroup
      column << host.lastseen.to_s
      column << host.mac
      column << host.vendor
      column << host.host_category.to_s
      column << host.location.try(:lid)
      column << "" # dummy for action links
    end
  end
end

RSpec.describe HostsDatatable, type: :model do
  include HostsDatatableHelper
  # order "name asc": MYNAS01, MYPC002, MYPC003, MYPC005, vpngw
  let!(:nas)  { FactoryGirl.create(:host, 
    name: "MYNAS01",
    description: "Backup station",
    ip: '198.51.100.17',
    cpe: "cpe:/o:linux:linux_kernel:2.6",
    raw_os: "storage-misc",
    fqdn: 'nas01.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    mac: '00:84:ed:12:34:56',
  )}
  let!(:pc2)  { FactoryGirl.create(:host, 
    name: "MYPC002",
    description: "workstation",
    ip: '198.51.100.65',
    cpe: "cpe:/o:microsoft:windows_7::sp1:professional",
    raw_os: "Windows 7 Professional 7601 Service Pack 1",
    fqdn: 'mypc002.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    mac: '00:84:ed:00:12:02',
  )}
  let!(:pc3)  { FactoryGirl.create(:host, 
    name: "MYPC003",
    description: "workstation",
    ip: '198.51.100.66',
    cpe: "cpe:/o:microsoft:windows_7::sp1:professional",
    raw_os: "Windows 7 Professional 7601 Service Pack 1",
    fqdn: 'mypc003.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    mac: '00:84:ed:00:12:03',
  )}
  let!(:vpngw)  { FactoryGirl.create(:host, 
    name: "vpngw",
    description: "VPN gateway",
    ip: '203.0.113.1',
    cpe: "cpe:/o:linux:linux_kernel:4.4",
    raw_os: "Linux 4.4",
    fqdn: 'vpngw.external.net',
    domain_dns: 'external.net',
    workgroup: '',
    lastseen: Date.today,
    mac: '12:34:56:99:99:98',
  )}
  let!(:pc5)  { FactoryGirl.create(:host, 
    name: "MYPC005",
    description: "very old workstation",
    ip: '198.51.100.70',
    cpe: "cpe:/o:microsoft:windows_xp::-",
    raw_os: "Windows 5.1",
    fqdn: 'mypc005.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    mac: '00:84:ed:00:12:05',
  )}
  let(:view_context) { double("ActionView::Base") }
  let(:hosts)        { Host.left_outer_joins(:location, :host_category) }
  let(:datatable)    { HostsDatatable.new(hosts, view_context) }

  before(:each) do
    allow(view_context).to receive(:params).and_return(myparams)
    allow(view_context).to receive_messages(
      edit_host_path: "",
      host_path: "",
      show_link: "",
      edit_link: "",
      delete_link: "",
      link_to: ""
    )
  end

  describe "without search params, start:0, length:10" do
    let(:myparams) {{
      order: {"0"=>{column: "0", dir: "desc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of HostsDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(5) }
    it { expect(parse_json(subject, "data/0")).to eq(host2array(vpngw)) }
    it { expect(parse_json(subject, "data/4")).to eq(host2array(nas)) }
  end 

  describe "without search params, start:2, length:2" do
    let(:myparams) {{
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "2",
      length: "2",
      search: {value: "", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(5) }
    it { expect(parse_json(subject, "data/0")).to eq(host2array(pc3)) }
    it { expect(parse_json(subject, "data/1")).to eq(host2array(pc5)) }
  end 

  describe "with search:nas" do
    let(:myparams) {{
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "nas", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(host2array(nas)) }
  end 

  describe "with search:198.51.100" do
    let(:myparams) {{
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "198.51.100", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(4) }
    it { expect(parse_json(subject, "data/0")).to eq(host2array(nas)) }
    it { expect(parse_json(subject, "data/3")).to eq(host2array(pc5)) }
  end 
end
