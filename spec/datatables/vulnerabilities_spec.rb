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
      column << vuln.vulnerability_detail.threat
      column << vuln.vulnerability_detail.severity.to_s
      column << vuln.lastseen.to_s
      column << "" # dummy for action links
    end
  end
end

RSpec.describe VulnerabilitiesDatatable, type: :model do
  include VulnerabilitiesDatatableHelper
  include_context "vulnerability variables"

  let(:view_context) { double("ActionView::Base") }
  let(:vulnerabilities) { Vulnerability.left_outer_joins(
    :vulnerability_detail, host: [ :host_category, :operating_system, :location ]
  )}
  let(:datatable)    { VulnerabilitiesDatatable.new(vulnerabilities, view_context) }

  before(:each) do
    allow(view_context).to receive(:params).and_return(myparams)
    allow(view_context).to receive_messages(
      edit_vulnerability_path: "",
      host_path: "",
      show_link: "",
      edit_link: "",
      delete_link: "",
      link_to: ""
    )
  end

  describe "without search params, start:0, length:10" do
    let(:myparams) {{
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "0", dir: "desc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of VulnerabilitiesDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(6) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(6) }
    it { expect(parse_json(subject, "data/0")).to eq(vuln2array(vuln11)) }
    it { expect(parse_json(subject, "data/5")).to eq(vuln2array(vuln33)) }
  end 

  describe "without search params, start:2, length:2" do
    let(:myparams) {{
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "0", dir: "asc"}},
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
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      "search"=> {"value"=>"Server", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(6) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(vuln2array(vuln33)) }
  end 

  describe "with search:198.51.100" do
    let(:myparams) {{
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      "search" => {"value" => "198.51.100", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(6) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(5) }
    it { expect(parse_json(subject, "data/0")).to eq(vuln2array(vuln11)) }
    it { expect(parse_json(subject, "data/1")).to eq(vuln2array(vuln12)) }
    it { expect(parse_json(subject, "data/2")).to eq(vuln2array(vuln13)) }
    it { expect(parse_json(subject, "data/3")).to eq(vuln2array(vuln22)) }
    it { expect(parse_json(subject, "data/4")).to eq(vuln2array(vuln23)) }
  end 
end