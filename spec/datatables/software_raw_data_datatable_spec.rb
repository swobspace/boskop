require 'rails_helper'

module SoftwareRawDataDatatableHelper
  def swr2array(swr)
    [].tap do |column|
      column << swr.name
      column << swr.version
      column << swr.vendor
      column << swr.count
      column << swr.operating_system
      column << swr.lastseen.to_s
      column << swr.source
      column << swr.software.to_s
      column << "  " # dummy for action links
    end
  end

  def link_helper(text, url)
    text
  end
end

RSpec.describe SoftwareRawDataDatatable, type: :model do
  include SoftwareRawDataDatatableHelper
  include_context "software_raw_data variables"

  let(:view_context) { double("ActionView::Base") }
  let(:software_raw_data) { SoftwareRawDatum.left_outer_joins(:software) }
  let(:datatable)    { SoftwareRawDataDatatable.new(software_raw_data, view_context) }

  before(:each) do
    allow(view_context).to receive(:params).and_return(myparams)
    allow(view_context).to receive_messages(
      edit_software_raw_datum_path: "",
      software_raw_datum_path: "",
      add_software_from_raw_data: "",
      software_path: "",
      show_link: "",
      edit_link: "",
      delete_link: "",
    )
    allow(view_context).to receive(:link_to) do |text, url|
      link_helper(text, url)
    end

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
    it { expect(datatable).to be_a_kind_of SoftwareRawDataDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(5) }
    it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw4)) }
    it { expect(parse_json(subject, "data/4")).to eq(swr2array(raw5)) }
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
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(5) }
    it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw2)) }
    it { expect(parse_json(subject, "data/1")).to eq(swr2array(raw1)) }
  end 

  describe "with search: tightvnc" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      "search"=> {"value"=>"tightvnc", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
    it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw5)) }
  end 

  describe "with search: pavlov" do
    let(:myparams) { ActiveSupport::HashWithIndifferentAccess.new(
      order: {"0"=>{column: "0", dir: "asc"}},
      start: "0",
      length: "10",
      "search" => {"value" => "pavlov", regex: "false"}
    )}
    subject { datatable.to_json }
    it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(2) }
    it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw4)) }
    it { expect(parse_json(subject, "data/1")).to eq(swr2array(raw3)) }
  end 

  describe "with search params, start:0, length:10" do
    subject { datatable.to_json }

    context "column 0: name, search: visual studio" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"0" => {search: {value: "visual studio", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(2) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw2)) }
      it { expect(parse_json(subject, "data/1")).to eq(swr2array(raw1)) }
    end

    context "column 1: version, search: 10" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"1" => {search: {value: "10", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(2) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw2)) }
      it { expect(parse_json(subject, "data/1")).to eq(swr2array(raw1)) }
    end

    context "column 2: vendor, search: microsoft" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"2" => {search: {value: "microsoft", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(2) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw2)) }
      it { expect(parse_json(subject, "data/1")).to eq(swr2array(raw1)) }
    end

    context "column 3: count, search: 44" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"3" => {search: {value: "44", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw3)) }
    end

    context "column 4: operating_system, search: windows" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"4" => {search: {value: "windows", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(5) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw4)) }
      it { expect(parse_json(subject, "data/4")).to eq(swr2array(raw5)) }
    end

    context "column 5: lastseen, search: 2019-10" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"5" => {search: {value: "2019-10", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw5)) }
    end

    context "column 6: source, search: other" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"6" => {search: {value: "other", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(2) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw4)) }
      it { expect(parse_json(subject, "data/1")).to eq(swr2array(raw5)) }
    end

    context "column 7: software, search: visual studio" do
      let(:myparams) {ActiveSupport::HashWithIndifferentAccess.new(
        columns: {"7" => {search: {value: "wrong", regex: "false"}}},
        order: {"0" => {"column" => "0", "dir" => "asc"}},
        start: "0", length: "10", search: {value: "", regex: "false"}
      )}
      it { expect(parse_json(subject, "recordsTotal")).to eq(5) }
      it { expect(parse_json(subject, "recordsFiltered")).to eq(1) }
      it { expect(parse_json(subject, "data/0")).to eq(swr2array(raw2)) }
    end
  end
end
