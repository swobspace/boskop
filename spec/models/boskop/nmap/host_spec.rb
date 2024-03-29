require 'rails_helper'
require 'nmap/xml'
  
RSpec.describe Boskop::NMAP::Host do
  let(:nmaphost) { ::Nmap::XML.open(nmapxml).host }

  # check for class methods
  it { expect(Boskop::NMAP::Host.respond_to? :new).to be_truthy}

  describe "without option :ip" do
    subject { Boskop::NMAP::Host.new() }
    it "::new raise an KeyError" do
      expect { Boskop::NMAP::Host.new() }.to raise_error(KeyError)   
    end
  end

  describe "with invalid nmaphost" do
    subject { Boskop::NMAP::Host.new(nmaphost: nil) }
    it { expect(subject).not_to be_valid }
  end

  describe "with valid nmaphost and script data" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'smb-os-discovery-42.xml') }
    subject { Boskop::NMAP::Host.new(nmaphost: nmaphost) }
    before(:each) do
      allow(subject).to receive(:domain_dns).and_return('mydomain.example.net')
    end

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::NMAP::Host }
    it { expect(subject).to be_valid }
    it { expect(subject.ip).to eq('192.168.1.42') }
    it { expect(subject.lastseen.to_s).to match(/\A2017-08-20 /) }
    it { expect(subject.hostname).to eq("wob42") }
    it { expect(subject.status).to eq("up") }
    it { expect(subject.cpe).to eq("/o:microsoft:windows_10::-") }
    it { expect(subject.raw_os).to eq("Windows 10 Pro 15063") }
    it { expect(subject.server).to eq("DESKTOP-6GLIL73") }
    it { expect(subject.fqdn).to eq("DESKTOP-6GLIL73") }
    it { expect(subject.mac).to eq("C8:FF:28:78:29:DB") }
    it { expect(subject.vendor).to eq("Liteon Technology") }
    it { expect(subject.attributes).to include(
           mac: "C8:FF:28:78:29:DB",
           vendor: "Liteon Technology",
           ip: '192.168.1.42',
           name: "wob42",
           status: "up",
           cpe: "/o:microsoft:windows_10::-",
           raw_os: "Windows 10 Pro 15063",
           server: "DESKTOP-6GLIL73",
           workgroup: "WORKGROUP",
           domain_dns: "mydomain.example.net",
           fqdn: "DESKTOP-6GLIL73") }
  end

  describe "with valid nmaphost and no script data" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-42.xml') }
    subject { Boskop::NMAP::Host.new(nmaphost: nmaphost) }

    it { expect(subject.ip).to eq('192.168.1.42') }
    it { expect(subject.lastseen.to_s).to match(/\A2017-08-20 /) }
    it { expect(subject.hostname).to eq("wobntb") }
    it { expect(subject.status).to eq("up") }
    it { expect(subject.mac).to eq("C8:FF:28:78:29:DB") }
    it { expect(subject.cpe).to be_nil }
    it { expect(subject.raw_os).to be_nil }
    it { expect(subject.server.blank?).to be_truthy }
    it { expect(subject.fqdn).to be_nil }
    it { expect(subject.attributes).to include(
           mac: "C8:FF:28:78:29:DB",
           ip: '192.168.1.42',
           name: "wobntb",
           status: "up") }
    it { expect(subject.attributes).not_to include( :cpe, :raw_os, :server, :fqdn )}
  end

  describe "with valid nmaphost without dns hostname" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'win-xp.xml') }
    subject { Boskop::NMAP::Host.new(nmaphost: nmaphost) }

    it "set hostname from script data" do
      expect(subject.hostname).to eq("w-ab8159b407254")
    end
  end

  describe "with ping only scan" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-ping.xml') }
    subject { Boskop::NMAP::Host.new(nmaphost: nmaphost, starttime: '2017-09-20') }

    it { expect(subject.ip).to eq('192.168.1.13') }
    it { expect(subject.lastseen.to_s).to match(/2017-09-20/) }
    it { expect(subject.hostname).to eq("wobgate") }
  end

  describe "with forced up state" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'force-hosts-up.xml') }
    let(:nmaphosts) { ::Nmap::XML.open(nmapxml).hosts }
    let(:host1)     { Boskop::NMAP::Host.new(nmaphost: nmaphosts[0]) }
    let(:host2)     { Boskop::NMAP::Host.new(nmaphost: nmaphosts[1]) }

    it { expect(host1.ip).to eq('192.168.1.13') }
    it { expect(host1.hostname).to eq("wobgate") }
    it { expect(host1.status).to eq('up') }
    it { expect(host1.up?).to be_truthy }
    it { expect(host2.ip).to eq('198.51.100.1') }
    it { expect(host2.hostname.nil?).to be_truthy}
    it { expect(host2.status).to eq('down') }
    it { expect(host2.up?).to be_falsey }
  end


end
