require 'rails_helper'
  
RSpec.describe Boskop::Nessus::ReportHost do
  let(:xmlfile) {"/home/wob/Projects/boskop/spec/fixtures/files/cry-nessus.xml"}
  let(:xmldoc)  { File.open(xmlfile) { |f| Nokogiri::XML(f) } }
  let(:report_host1) { xmldoc.xpath("//NessusClientData_v2/Report/ReportHost")[0] }
  let(:report_host2) { xmldoc.xpath("//NessusClientData_v2/Report/ReportHost")[1] }

  # check for class methods
  it { expect(Boskop::Nessus::ReportHost.respond_to? :new).to be_truthy}

  describe "without option :report_host" do
    subject { Boskop::Nessus::ReportHost.new() }
    it "::new raise an KeyError" do
      expect { Boskop::Nessus::ReportHost.new() }.to raise_error(KeyError)   
    end
  end

  describe "with invalid report_host" do
    subject { Boskop::Nessus::ReportHost.new(report_host: nil) }
    it { expect(subject).not_to be_valid }
  end

  describe "with valid xml report_host2" do
    subject { Boskop::Nessus::ReportHost.new(report_host: report_host2) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::Nessus::ReportHost }
    it { expect(subject).to be_valid }
    it { expect(subject.lastseen.to_s).to match(/\A2018-06-04T12:57:46+/) }
    it { expect(subject.ip).to eq('192.0.2.244') }
    it { expect(subject.name).to eq("WS1228") }
    it { expect(subject.mac).to eq("34:17:eb:b6:60:6b") }
    it { expect(subject.fqdn).to eq("ws1228") }
    it { expect(subject.raw_os).to eq("Microsoft Windows 7 Professional") }
    
    it { expect(subject.attributes).to include(
           lastseen: "2018-06-04T12:57:46+00:00",
           ip: '192.0.2.244',
           name: "WS1228",
           mac:  "34:17:eb:b6:60:6b",
           fqdn:  "ws1228",
           raw_os: "Microsoft Windows 7 Professional",
           ) }
  end

  describe "within report_host1" do
    subject { Boskop::Nessus::ReportHost.new(report_host: report_host1) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::Nessus::ReportHost }
    it { expect(subject).to be_valid }
    it { expect(subject.all? {|o| o.kind_of? Boskop::Nessus::ReportItem}).to be_truthy }
    it { expect(subject.report_items.first).to be_a_kind_of Boskop::Nessus::ReportItem }

    describe "with first report_item" do
      let(:report_item) { (subject.report_items.first) }

      it { expect(report_item.oid).to eq("nessus:19506") }
      it { expect(report_item.name).to eq("Nessus Scan Information") }
      it { expect(report_item.threat).to eq("None") }
      it { expect(report_item.solution).to eq("n/a") }
      it { expect(report_item.synopsis).to eq("This plugin displays information about the Nessus scan.") }
    end
  end

end
