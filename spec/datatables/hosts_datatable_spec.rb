require 'rails_helper'

module HostsDatatableHelper
  def host2array(host)
    [].tap do |column|
      column << host.name
      column << host.description
      column << host.ip.to_s
      column << host.operating_system.to_s
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
  include_context "host variables"

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
      columns: {"0"=> {search: {value: ""}}},
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
      columns: {"0"=> {search: {value: ""}}},
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
      "search"=> {"value"=>"nas", regex: "false"}
    }}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(host2array(nas)) }
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
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(4) }
    it { expect(parse_json(subject, "data/0")).to eq(host2array(nas)) }
    it { expect(parse_json(subject, "data/3")).to eq(host2array(pc5)) }
  end 
end
