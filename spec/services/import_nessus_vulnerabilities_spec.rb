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
    it "creates a vulnerability", broken: true do
      expect {
	subject.call
      }.to change{Vulnerability.count}.by(5)
    end
    it "creates a vulnerability_detail", broken: true do
      expect {
	subject.call
      }.to change{VulnerabilityDetail.count}.by(5)
    end
  end

  describe "importing data from xml" do
    describe "#call" do
      let(:result) { subject.call }
      it { expect(result.success?).to be_truthy }
      it { expect(result.error_message.present?).to be_falsey }
      it { expect(result.vulnerabilities).to be_a_kind_of Array }
      it { expect(result.vulnerability_details).to be_a_kind_of Array }
      it { expect(result.hosts).to be_a_kind_of Array }

      describe "the first host" do
        let(:host) { result.hosts[0] }
        it { expect(host.lastseen.to_s).to eq("2018-06-10") }
        it { expect(host.ip).to eq("192.168.1.87") }
        it { expect(host.name).to eq("W-AB8159B407254") }
        it { expect(host.mac).to eq("00:21:85:54:b2:3e") }
        it { expect(host.raw_os).to eq("Microsoft Windows XP Service Pack 2\nMicrosoft Windows XP Service Pack 3\nWindows XP for Embedded Systems") }
        it { expect(host.fqdn).to eq(nil) }
      end

      describe "the first vulnerability", broken: true do
	let(:vulnerability) { result.vulnerabilities.first }
	let(:vulndetail)             { result.vulnerability_details.first }

	it { expect(vulnerability).to be_a_kind_of Vulnerability }
	it { expect(vulndetail).to be_a_kind_of VulnerabilityDetail }
	it { expect(vulnerability).to be_persisted }
	it { expect(vulndetail).to be_persisted }
	it { expect(vulnerability.host.ip.to_s).to eq("127.0.0.1") }
        it { expect(vulnerability.lastseen.to_s).to match(/\A2017-09-26\z/) }
	it { expect(vulndetail.name).to eq("OS End Of Life Detection") }
        it { expect(vulndetail.family).to eq("General") }
        it { expect(vulndetail.severity.to_s).to eq("10.0") }
        it { expect(vulndetail.threat).to eq("High") }
        it { expect(vulndetail.nvt).to eq("1.3.6.1.4.1.25623.1.0.103674") }
        it { expect(vulndetail.cves).to contain_exactly() }
        it { expect(vulndetail.bids).to contain_exactly() }
        it { expect(vulndetail.xrefs).to contain_exactly() }
        it { expect(vulndetail.certs).to contain_exactly() }
      end

      describe "the second vulnerability", broken: true do
	let(:vulnerability) { result.vulnerabilities.last }
	let(:vulndetail)             { result.vulnerability_details.last }

	it { expect(vulnerability).to be_a_kind_of Vulnerability }
	it { expect(vulndetail).to be_a_kind_of VulnerabilityDetail }
	it { expect(vulnerability).to be_persisted }
	it { expect(vulndetail).to be_persisted }
	it { expect(vulnerability.host.ip.to_s).to eq("127.0.0.1") }
        it { expect(vulnerability.lastseen.to_s).to match(/\A2017-09-26\z/) }
        it { expect(vulndetail.nvt).to eq("1.3.6.1.4.1.25623.1.0.810676") }
        it { expect(vulndetail.name).to eq("Microsoft Windows SMB Server Multiple Vulnerabilities-Remote (4013389)") }
        it { expect(vulndetail.family).to eq("Windows : Microsoft Bulletins") }
        it { expect(vulndetail.severity.to_s).to eq("9.3") }
        it { expect(vulndetail.threat).to eq("High") }
        it { expect(vulndetail.cves).to contain_exactly("CVE-2017-0143", "CVE-2017-0144", "CVE-2017-0145", "CVE-2017-0146", "CVE-2017-0147", "CVE-2017-0148") }
        it { expect(vulndetail.nvt).to eq("1.3.6.1.4.1.25623.1.0.810676") }
        it { expect(vulndetail.bids).to contain_exactly("96703", "96704", "96705", "96707", "96709", "96706") }
        it { expect(vulndetail.notes).to be_a_kind_of Hash }
        it { expect(vulndetail.notes).to include(
               "cvss_base_vector"=>"AV:N/AC:M/Au:N/C:C/I:C/A:C",
               "summary"=>"This host is missing a critical security\n  update according to Microsoft Bulletin MS17-010.",
               "solution_type"=>"VendorFix", "qod_type"=>"remote_active"
           )}
        it { expect(vulndetail.xrefs).to contain_exactly("URL:https://support.microsoft.com/en-in/kb/4013078", "URL:https://technet.microsoft.com/library/security/MS17-010", "URL:https://github.com/rapid7/metasploit-framework/pull/8167/files") }
        it { expect(vulndetail.certs).to contain_exactly(
                                       {"id" => "CB-K17/0435", "type" => "CERT-Bund"},
                                       {"id" => "DFN-CERT-2017-0448", "type" => "DFN-CERT"}) }
      end
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
  
  describe "with existing host and vulnerability", broken: true do
    let!(:vuln_detail) { FactoryBot.create(:vulnerability_detail,
      name: "OS End Of Life Detection",
      family: "General",
      severity: "10.0",
      threat: "High",
      nvt: "1.3.6.1.4.1.25623.1.0.103674",
    )}
    let(:host) { FactoryBot.create(:host, ip: '127.0.0.1', lastseen: '2017-08-31')}
    let!(:vuln) { FactoryBot.create(:vulnerability,
      vulnerability_detail: vuln_detail,
      host: host
    )}

    describe "newer than import data" do
      before(:each) do
        vuln.update(lastseen: '2017-10-01')
        host.update(lastseen: '2017-10-01')
      end
      it { expect { subject.call }.to change(Host, :count).by(0) }
      it { expect { subject.call }.to change(Vulnerability, :count).by(1) }
      it { expect { subject.call }.to change(VulnerabilityDetail, :count).by(1) }
      context "#call" do
        before(:each) do
          subject.call
          vuln.reload ; host.reload
        end
        it { expect(vuln.lastseen.to_s).to match(/\A2017-10-01\z/) }
        it { expect(host.lastseen.to_s).to match(/\A2017-10-01\z/) }
      end
    end

    describe "older than import data" do
      before(:each) do
        vuln.update(lastseen: '2017-01-01')
        host.update(lastseen: '2017-01-01')
      end
      it { expect { subject.call }.to change(Host, :count).by(0) }
      it { expect { subject.call }.to change(Vulnerability, :count).by(1) }
      it { expect { subject.call }.to change(VulnerabilityDetail, :count).by(1) }
      context "#call" do
        before(:each) do
          subject.call
          vuln.reload ; host.reload
        end
        it { expect(vuln.lastseen.to_s).to match(/\A2017-09-26\z/) }
        it { expect(host.lastseen.to_s).to match(/\A2017-09-26\z/) }
      end
    end
  end
end
