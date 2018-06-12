require 'rails_helper'

RSpec.describe ImportNessusVulnerabilitiesService do
  let(:nessusxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'netxp-nessus.xml') }
  subject { ImportNessusVulnerabilitiesService.new(file: nessusxml) }

  # check for class methods
  it { expect(ImportNessusVulnerabilitiesService.respond_to? :new).to be_truthy}

  # check for instance methods
  describe "instance methods" do
    subject { ImportNessusVulnerabilitiesService.new(file: "") }
    it { expect(subject.respond_to? :call).to be_truthy}
    it { expect(subject.call.respond_to? :success?).to be_truthy }
    it { expect(subject.call.respond_to? :error_message).to be_truthy }
    it { expect(subject.call.respond_to? :vulnerabilities).to be_truthy }
    it { expect(subject.call.respond_to? :vulnerability_details).to be_truthy }
  end

  context "data from nonexistent host" do
    it "creates an host" do
      expect {
	subject.call
      }.to change{Host.count}.by(1)
    end
    it "creates 5 vulnerabilities" do
      expect {
	subject.call
      }.to change{Vulnerability.count}.by(5)
    end
    it "creates 5 vulnerability_details" do
      expect {
	subject.call
      }.to change{VulnerabilityDetail.count}.by(5)
    end
  end

  describe "#call" do
    let(:result) { subject.call }
    it { expect(result.success?).to be_truthy }
    it { expect(result.error_message.present?).to be_falsey }
    it { expect(result.vulnerabilities).to be_a_kind_of Array }
    it { expect(result.vulnerability_details).to be_a_kind_of Array }
    it { expect(result.hosts).to be_a_kind_of Array }
  end

  describe "importing host from xml" do
    let(:result) { subject.call }

    describe "create a nonexisting host" do
      let(:host) { result.hosts[0] }
      it { expect(host.lastseen.to_s).to eq("2018-06-10") }
      it { expect(host.ip).to eq("192.168.1.87") }
      it { expect(host.name).to eq("W-AB8159B407254") }
      it { expect(host.mac).to eq("00:21:85:54:b2:3e") }
      it { expect(host.raw_os).to eq("Microsoft Windows XP Service Pack 2\nMicrosoft Windows XP Service Pack 3\nWindows XP for Embedded Systems") }
      it { expect(host.fqdn).to eq("") }
    end

    describe "update an existing host with older data" do
      let(:host) { result.hosts[0] }
      let!(:oldhost) { FactoryBot.create(:host, 
        ip: '192.168.1.87', 
        name: "nobody",
        raw_os: "empty",
        mac: "12:34:56:78:AA:BB",
        fqdn: "nobody.example.com",
        lastseen: "2017-01-01"
      )}
      it { expect(host.lastseen.to_s).to eq("2018-06-10") }
      it { expect(host.ip).to eq("192.168.1.87") }
      it { expect(host.name).to eq("W-AB8159B407254") }
      it { expect(host.mac).to eq("00:21:85:54:b2:3e") }
      it { expect(host.raw_os).to eq("Microsoft Windows XP Service Pack 2\nMicrosoft Windows XP Service Pack 3\nWindows XP for Embedded Systems") }
      it { expect(host.fqdn).to eq("nobody.example.com") }
    end

    describe "does not update an existing host with newer data" do
      let(:host) { result.hosts[0] }
      let!(:oldhost) { FactoryBot.create(:host, 
        ip: '192.168.1.87', 
        name: "nobody",
        raw_os: "empty",
        mac: "12:34:56:78:AA:BB",
        fqdn: "nobody.example.com",
        lastseen: "2018-06-30"
      )}
      it { expect(host.lastseen.to_s).to eq("2018-06-30") }
      it { expect(host.ip).to eq("192.168.1.87") }
      it { expect(host.name).to eq("nobody") }
      it { expect(host.mac).to eq("12:34:56:78:AA:BB") }
      it { expect(host.raw_os).to eq("empty") }
      it { expect(host.fqdn).to eq("nobody.example.com") }
    end
  end

  describe "importing data from xml" do
    let(:result) { subject.call }

    describe "the first vulnerability" do
      let(:vulnerability) { result.vulnerabilities.first }
      let(:vulndetail)    { result.vulnerability_details.first }

      it { expect(vulnerability).to be_a_kind_of Vulnerability }
      it { expect(vulndetail).to be_a_kind_of VulnerabilityDetail }
      it { expect(vulnerability).to be_persisted }
      it { expect(vulndetail).to be_persisted }
      it { expect(vulnerability.host.ip.to_s).to eq("192.168.1.87") }
      it { expect(vulnerability.lastseen.to_s).to match(/\A2018-06-10\z/) }
      it { expect(vulndetail.name).to eq("Unsupported Windows OS") }
      it { expect(vulndetail.family).to eq("Windows") }
      it { expect(vulndetail.severity.to_s).to eq("10.0") }
      it { expect(vulndetail.threat).to eq("Critical") }
      it { expect(vulndetail.nvt).to eq("nessus:108797") }
      it { expect(vulndetail.cves).to contain_exactly() }
      it { expect(vulndetail.bids).to contain_exactly() }
      it { expect(vulndetail.xrefs).to contain_exactly() }
      it { expect(vulndetail.certs).to contain_exactly() }
    end

    describe "the second vulnerability" do
      let(:vulnerability) { result.vulnerabilities[1] }
      let(:vulndetail)             { result.vulnerability_details[1] }

      it { expect(vulnerability).to be_a_kind_of Vulnerability }
      it { expect(vulndetail).to be_a_kind_of VulnerabilityDetail }
      it { expect(vulnerability).to be_persisted }
      it { expect(vulndetail).to be_persisted }
      it { expect(vulnerability.host.ip.to_s).to eq("192.168.1.87") }
      it { expect(vulnerability.lastseen.to_s).to match(/\A2018-06-10\z/) }
      it { expect(vulndetail.nvt).to eq("nessus:100464") }
      it { expect(vulndetail.name).to eq("Microsoft Windows SMBv1 Multiple Vulnerabilities")}
      it { expect(vulndetail.family).to eq("Windows") }
      it { expect(vulndetail.severity.to_s).to eq("10.0") }
      it { expect(vulndetail.threat).to eq("Critical") }
      it { expect(vulndetail.cves).to contain_exactly( "CVE-2017-0267", "CVE-2017-0268", 
             "CVE-2017-0269", "CVE-2017-0270", "CVE-2017-0271", "CVE-2017-0272", 
             "CVE-2017-0273", "CVE-2017-0274", "CVE-2017-0275", "CVE-2017-0276", 
             "CVE-2017-0277", "CVE-2017-0278", "CVE-2017-0279", "CVE-2017-0280" )}
      it { expect(vulndetail.nvt).to eq("nessus:100464") }
      it { expect(vulndetail.bids).to contain_exactly( "98259", "98260", "98261", 
             "98263", "98264", "98265", "98266", "98267", "98268", "98270", 
             "98271", "98272", "98273", "98274" ) }
      it { expect(vulndetail.notes).to be_a_kind_of Hash }
      it { expect(vulndetail.notes.keys).to contain_exactly("description", "synopsis",
             "see_also", "solution", "vuln_publication_date", "patch_publication_date",
             "exploit_available", "exploited_by_malware" )}
      it { expect(vulndetail.xrefs).to contain_exactly( "OSVDB:157230", "OSVDB:157231",
             "OSVDB:157232", "OSVDB:157233", "OSVDB:157234", "OSVDB:157235",
             "OSVDB:157236", "OSVDB:157237", "OSVDB:157238", "OSVDB:157239",
             "OSVDB:157240", "OSVDB:157246", "OSVDB:157247", "OSVDB:157248",
             "MSKB:4016871", "MSKB:4018466", "MSKB:4019213", "MSKB:4019214",
             "MSKB:4019215", "MSKB:4019216", "MSKB:4019263", "MSKB:4019264",
             "MSKB:4019472", "MSKB:4019473", "MSKB:4019474" )}
    end
  end

  context "with invalid import_attributes" do
    subject { ImportNessusVulnerabilitiesService.new(file: "") }

    it "does not create a Host" do
      expect {
	subject.call
      }.to change{Host.count}.by(0)
    end

    describe "#call" do
      let(:result) { subject.call }
      it { expect(result.success?).to be_falsey }
      it { expect(result.error_message.present?).to be_truthy }
      it { expect(result.hosts.first).to be_nil }
    end
  end
  
  describe "with existing host and vulnerability" do
    let!(:vuln_detail) { FactoryBot.create(:vulnerability_detail,
      name: "Unsupported Windows OS",
      family: "Windows",
      severity: "10.0",
      threat: "Critical",
      nvt: "nessus:108797",
    )}
    let(:host) { FactoryBot.create(:host, ip: '192.168.1.87', lastseen: '2017-08-31')}
    let!(:vuln) { FactoryBot.create(:vulnerability,
      vulnerability_detail: vuln_detail,
      host: host
    )}

    describe "newer than import data" do
      before(:each) do
        vuln.update(lastseen: '2018-06-30')
        host.update(lastseen: '2018-06-30')
      end
      it { expect { subject.call }.to change(Host, :count).by(0) }
      it { expect { subject.call }.to change(Vulnerability, :count).by(4) }
      it { expect { subject.call }.to change(VulnerabilityDetail, :count).by(4) }
      context "#call" do
        before(:each) do
          subject.call
          vuln.reload ; host.reload
        end
        it { expect(vuln.lastseen.to_s).to match(/\A2018-06-30\z/) }
        it { expect(host.lastseen.to_s).to match(/\A2018-06-30\z/) }
      end
    end

    describe "older than import data" do
      before(:each) do
        vuln.update(lastseen: '2017-01-01')
        host.update(lastseen: '2017-01-01')
      end
      it { expect { subject.call }.to change(Host, :count).by(0) }
      it { expect { subject.call }.to change(Vulnerability, :count).by(4) }
      it { expect { subject.call }.to change(VulnerabilityDetail, :count).by(4) }
      context "#call" do
        before(:each) do
          subject.call
          vuln.reload ; host.reload
        end
        it { expect(vuln.lastseen.to_s).to match(/\A2018-06-10\z/) }
        it { expect(host.lastseen.to_s).to match(/\A2018-06-10\z/) }
      end
    end
  end
end
