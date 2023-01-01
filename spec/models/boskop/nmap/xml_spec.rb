require 'rails_helper'
  
RSpec.describe Boskop::NMAP::XML do
  let!(:testpdf) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.pdf') }
  let!(:invalidxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-invalid.xml') }

  # check for class methods
  it { expect(Boskop::NMAP::XML.respond_to? :new).to be_truthy}

  describe "without option :file" do
    subject { Boskop::NMAP::XML.new() }
    it "::new raise an KeyError" do
      expect { Boskop::NMAP::XML.new() }.to raise_error(KeyError)   
    end
  end

  describe "with wrong file format" do
    subject { Boskop::NMAP::XML.new(file: testpdf) }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with invalid xml file" do
    subject { Boskop::NMAP::XML.new(file: invalidxml) }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with empty input file" do
    subject { Boskop::NMAP::XML.new(file: "") }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with valid input xml file without script_data" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-42.xml') }
    subject { Boskop::NMAP::XML.new(file: nmapxml) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :file).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject.respond_to? :error_message).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::NMAP::XML }
    it { expect(subject).to be_valid }
    it { expect(subject.all_hosts.first).to be_a_kind_of Boskop::NMAP::Host }
    it { expect(subject.starttime.to_s).to match(/\A2017-08-20 /) }

  end

  context "input data with down host" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'down.xml') }

    describe "#all_hosts(force: true)" do
      let(:xml) { Boskop::NMAP::XML.new(file: nmapxml) }
      it { expect(xml.all_hosts(force: true).first.ip.to_s).to eq("198.51.100.1") }
    end

    describe "#all_hosts(force: false)" do
      let(:xml) { Boskop::NMAP::XML.new(file: nmapxml) }
      it { expect(xml.all_hosts(force: false)).to contain_exactly() }
    end
  end

  describe "with valid input xml file and script_data" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'smb-os-discovery-42.xml') }
    subject { Boskop::NMAP::XML.new(file: nmapxml) }

    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::NMAP::XML }
    it { expect(subject).to be_valid }
    it { expect(subject.all_hosts.first).to be_a_kind_of Boskop::NMAP::Host }
  end

  describe "with ping only nmap scan" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-ping.xml') }
    subject { Boskop::NMAP::XML.new(file: nmapxml) }

    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::NMAP::XML }
    it { expect(subject).to be_valid }
    it { expect(subject.all_hosts.first).to be_a_kind_of Boskop::NMAP::Host }
    it { expect(subject.starttime.to_s).to match(/\A2017-09-20 /) }
  end

  describe "with forced up hosts" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'force-hosts-up.xml') }
    subject { Boskop::NMAP::XML.new(file: nmapxml) }

    it { expect(subject).to be_valid }
    it { expect(subject.all_hosts.count).to eq(1) }
    it { expect(subject.all_hosts.map(&:ip)).to contain_exactly('192.168.1.13') }
  end

end
