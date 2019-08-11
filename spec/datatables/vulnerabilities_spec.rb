require 'rails_helper'

module VulnerabilitiesDatatableHelper
  def vuln2array(vuln)
    [].tap do |column|
      column << vuln.host.location.try(:lid)
      column << vuln.host.ip.to_s
      column << vuln.host.name
      column << vuln.host.host_category.to_s
      column << vuln.host.operating_system.to_s
      column << vuln.vulnerability_detail.to_s
      column << vuln.vulnerability_detail&.nvt
      column << vuln.plugin_output
      column << vuln.vulnerability_detail.threat
      column << vuln.vulnerability_detail.severity.to_s
      column << vuln.lastseen.to_s
      column << vuln.created_at.to_date.to_s
      column << "  " # dummy for action links
    end
  end

  def link_helper(text, url)
    text
  end
end

RSpec.describe VulnerabilitiesDatatable, type: :model do
  include VulnerabilitiesDatatableHelper
  include_context "vulnerability variables"

  let(:view_context) { double("ActionView::Base") }
  let(:vulnerabilities) { Vulnerability.left_outer_joins(
    :vulnerability_detail, host: [ :network_interfaces, :host_category, :operating_system, :location ]
  )}
  let(:datatable)    { VulnerabilitiesDatatable.new(vulnerabilities, view_context) }

  before(:each) do
    allow(view_context).to receive(:params).and_return(myparams)
    allow(view_context).to receive_messages(
      edit_vulnerability_path: "",
      vulnerability_detail_path: "",
      vulnerability_path: "",
      host_path: "",
      show_link: "",
      edit_link: "",
      delete_link: "",
    )
    allow(view_context).to receive(:link_to).with('198.51.100.17', any_args).and_return('198.51.100.17')
    allow(view_context).to receive(:link_to).with('198.51.100.71', any_args).and_return('198.51.100.71')
    allow(view_context).to receive(:link_to).with('192.0.2.17', any_args).and_return('192.0.2.17')
    allow(view_context).to receive(:link_to).with('pc4.my.domain', any_args).and_return('pc4.my.domain')
    allow(view_context).to receive(:link_to).with('pc5.my.domain', any_args).and_return('pc5.my.domain')
    allow(view_context).to receive(:link_to).with('abc.other.domain', any_args).and_return('abc.other.domain')
    allow(view_context).to receive(:link_to).with('4013389', any_args).and_return('4013389')
    allow(view_context).to receive(:link_to).with('Old MySQL', any_args).and_return('Old MySQL')
    allow(view_context).to receive(:link_to).with('Old Service', any_args).and_return('Old Service')
  end

  describe "without search params, start:0, length:10" do
    let(:myparams) {{
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "1", dir: "desc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of VulnerabilitiesDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(6) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(6) }
    it { expect(parse_json(subject, "data/0")).to eq(vuln2array(vuln22)) }
    it { expect(parse_json(subject, "data/5")).to eq(vuln2array(vuln33)) }
  end 

  describe "without search params, start:2, length:2" do
    let(:myparams) {{
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "1", dir: "asc"}},
      start: "2",
      length: "2",
      search: {value: "", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(6) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(6) }
    it { expect(parse_json(subject, "data/0")).to eq(vuln2array(vuln12)) }
    it { expect(parse_json(subject, "data/1")).to eq(vuln2array(vuln13)) }
  end 

  describe "with search: Server" do
    let(:myparams) {{
      order: {"0"=>{column: "1", dir: "asc"}},
      start: "0",
      length: "10",
      "search"=> {"value"=>"Server", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(6) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(vuln2array(vuln33)) }
  end 

  describe "with search:198.51.100.7" do
    let(:myparams) {{
      order: {"0"=>{column: "7", dir: "desc"}},
      start: "0",
      length: "10",
      "search" => {"value" => "198.51.100.7", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(6) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(2) }
    it { expect(parse_json(subject, "data/0")).to eq(vuln2array(vuln22)) }
    it { expect(parse_json(subject, "data/1")).to eq(vuln2array(vuln23)) }
  end 
end
