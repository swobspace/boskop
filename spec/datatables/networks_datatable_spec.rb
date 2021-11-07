require 'rails_helper'

module NetworksDatatableHelper
  include ApplicationHelper
  def network2array(network)
    [].tap do |column|
        column << network.netzwerk&.to_cidr_s
        column << network.description
        column << network.location&.lid
        column << network.location.to_s
        column << network.location&.ort
        Merkmalklasse.visibles(:network, 'index').each do |mklasse|
          column << get_merkmal(network, mklasse)
        end

      column << "  " # dummy for action links
    end
  end
end

RSpec.describe NetworksDatatable, type: :model do
  include NetworksDatatableHelper
  include_context "network variables"

  let(:view_context) { double("ActionView::Base") }
  let(:networks)        { Network.left_outer_joins(:merkmale, :location) }
  let(:datatable)    { NetworksDatatable.new(networks, view_context) }
  let(:myparams)  {{}}

  before(:each) do
    allow(view_context).to receive(:params).and_return(myparams)
    allow(view_context).to receive(:get_merkmal).with(net1,any_args).and_return("1011")
    allow(view_context).to receive_messages(
      edit_network_path: "",
      network_path: "",
      show_link: "",
      edit_link: "",
      delete_link: "",
      link_to: ""
    )
    paris.addresses << addr_paris
    berlin.addresses << addr_berlin
    london.addresses << addr_london
  end

  describe "without search params, start:0, length:10" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworksDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(3) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net2)) }
    it { expect(parse_json(subject, "data/2")).to eq(network2array(net3)) }
  end 

  describe "without search params, start:2, length:2" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"0"=> {search: {value: ""}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "2",
      length: "2",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(3) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net3)) }
  end 

  describe "column 0: netzwerk, search: 192.0.2.0" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"0"=> {search: {value: "192.0.2.0", regex: "false"}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworksDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net2)) }
  end 

  describe "column 1: description " do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"1"=> {search: {value: "netzwerk paris", regex: "false"}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworksDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net3)) }
  end 

  describe "column 2: lid " do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"2"=> {search: {value: "BER", regex: "false"}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworksDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net1)) }
  end 

  describe "column 3: location" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"3"=> {search: {value: "London City", regex: "false"}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworksDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net2)) }
  end 

  describe "column 4: ort" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"4"=> {search: {value: "Berlin", regex: "false"}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworksDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net1)) }
  end 

  describe "column 5: merkmal vlan" do
    let(:merkmalklasse1) { FactoryBot.create(:merkmalklasse,
      name: 'VLAN',
      tag: 'vlan',
      format: 'number',
      for_object: 'Network',
      visible: ['index', '']
    )}

    let!(:merkmal1) { FactoryBot.create(:merkmal,
      merkmalfor: net1,
      merkmalklasse: merkmalklasse1,
      value: 1011
    )}

    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      columns: {"5"=> {search: {value: "1011", regex: "false"}}},
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      search: {value: "", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(datatable).to be_a_kind_of NetworksDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(network2array(net1)) }
  end 

  # it { puts london.inspect }
end
