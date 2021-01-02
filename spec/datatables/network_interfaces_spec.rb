require 'rails_helper'

module NetworkInterfacesDatatableHelper
  def iface2array(iface)
    [].tap do |column|
      column << iface.host.location.try(:lid)
      column << iface.host.name
      column << iface.ip.to_s
      column << iface.mac.to_s
      column << iface.if_description
      column << iface.lastseen.to_s
      column << iface.created_at.to_date.to_s
      column << "  " # dummy for action links
    end
  end

  def link_helper(text, url)
    text
  end
end

RSpec.describe NetworkInterfacesDatatable, type: :model do
  include NetworkInterfacesDatatableHelper
  include_context "network_interface variables"

  let(:view_context) { double("ActionView::Base") }
  let(:ifaces)       { NetworkInterface.left_outer_joins( host: [ :location ] )}
  let(:datatable)    { NetworkInterfacesDatatable.new(ifaces, view_context) }

  before(:each) do
    allow(view_context).to receive(:params).and_return(myparams)
    allow(view_context).to receive_messages(
      edit_network_interface_path: "",
      network_interface_path: "",
      host_path: "",
      show_link: "",
      edit_link: "",
      delete_link: "",
    )
    allow(view_context).to receive(:link_to).with('pc4.my.domain', any_args).and_return('pc4.my.domain')
    allow(view_context).to receive(:link_to).with('pc5.my.domain', any_args).and_return('pc5.my.domain')
    allow(view_context).to receive(:link_to).with('abc.other.domain', any_args).and_return('abc.other.domain')
  end

  describe "without search params, start:0, length:10" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "1", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworkInterfacesDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(4) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(4) }
    it { expect(parse_json(subject, "data/0")).to eq(iface2array(if1_host3)) }
    it { expect(parse_json(subject, "data/1")).to eq(iface2array(if2_host3)) }
  end 

  describe "without search params, start:2, length:2" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "1", dir: "asc"}},
      start: "2",
      length: "2",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(4) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(4) }
    it { expect(parse_json(subject, "data/0")).to eq(iface2array(if_host1)) }
    it { expect(parse_json(subject, "data/1")).to eq(iface2array(if_host2)) }
  end 

  describe "with search: bbelfas" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      order: {"0"=>{column: "1", dir: "asc"}},
      start: "0",
      length: "10",
      "search"=> {"value"=>"bbelfas", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(4) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(iface2array(if_host1)) }
  end 

  describe "with search:198.51.100.7" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      order: {"0"=>{column: "2", dir: "desc"}},
      start: "0",
      length: "10",
      "search" => {"value" => "198.51.100.7", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(4) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(iface2array(if_host2)) }
  end 
end
