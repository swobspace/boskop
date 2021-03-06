require 'rails_helper'
  
RSpec.describe Boskop::Nessus::ComputerSystemProduct do
  let(:xmlfile) {"/home/wob/Projects/boskop/spec/fixtures/files/ws1020_48337.nessus"}
  let(:xmldoc)  { File.open(xmlfile) { |f| Nokogiri::XML(f) } }
  let(:report_host) { Boskop::Nessus::ReportHost.new(report_host: xmldoc.xpath("//NessusClientData_v2/Report/ReportHost")[0]) }
  let(:plugin_output) { "\n+ Computersystemprodukt\n  - IdentifyingNumber : ZZZ4DTAG\n  - Description       : Computersystemprodukt\n  - Vendor            : Dell Inc.\n  - Name              : OptiPlex 3020\n  - UUID              : FA289A70-4803-11E9-8CCD-111222333444\n  - Version           : 01\n\n" }

  # check for class methods
  it { expect(Boskop::Nessus::ComputerSystemProduct.respond_to? :new).to be_truthy}

  describe "without option :report_host" do
    it "::new raise an KeyError" do
      expect { Boskop::Nessus::ComputerSystemProduct.new() }.to raise_error(KeyError)   
    end
  end

  describe "with invalid report_host" do
    it "::new raise an KeyError" do
      expect { Boskop::Nessus::ComputerSystemProduct.new(report_host: nil) }.to raise_error(KeyError)   
    end
  end

  describe "report_host with plugin data" do
    subject { Boskop::Nessus::ComputerSystemProduct.new(report_host: report_host) }

    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::Nessus::ComputerSystemProduct }
    it { expect(subject).to be_valid }
    it { expect(subject.raw_output).to eq(plugin_output) }
    it { expect(subject.identifying_number).to eq("ZZZ4DTAG") }
    it { expect(subject.description).to eq("Computersystemprodukt") }
    it { expect(subject.vendor).to eq("Dell Inc.") }
    it { expect(subject.name).to eq("OptiPlex 3020") }
    it { expect(subject.uuid).to eq("FA289A70-4803-11E9-8CCD-111222333444") }
    it { expect(subject.version).to eq("01") }
    it { expect(subject.attributes).to include(
           serial: "ZZZ4DTAG",
           vendor: "Dell Inc.",
           product: "OptiPlex 3020",
       )}
    it { expect(subject.attributes).not_to include(:uuid) }
  end

  describe "report_host missing plugin data" do
    let(:xmlfile) {"/home/wob/Projects/boskop/spec/fixtures/files/cry-nessus.xml"}
    subject { Boskop::Nessus::ComputerSystemProduct.new(report_host: report_host) }

    it { expect(subject).to be_a_kind_of Boskop::Nessus::ComputerSystemProduct }
    it { expect(subject).not_to be_valid }
    it { expect(subject.raw_output).to eq(nil) }
    it { expect(subject.vendor).to eq(nil) }
    it { expect(subject.name).to eq(nil) }
    it { expect(subject.uuid).to eq(nil) }
    it { expect(subject.description).to eq(nil) }
    it { expect(subject.version).to eq(nil) }
  end
end
