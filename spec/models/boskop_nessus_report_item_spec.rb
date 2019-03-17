require 'rails_helper'
  
RSpec.describe Boskop::Nessus::ReportItem do
  let(:xmlfile) {"/home/wob/Projects/boskop/spec/fixtures/files/cry-nessus.xml"}
  let(:xmldoc)  { File.open(xmlfile) { |f| Nokogiri::XML(f) } }
  let(:report_host1) { xmldoc.xpath("//NessusClientData_v2/Report/ReportHost")[0] }
  let(:report_host2) { xmldoc.xpath("//NessusClientData_v2/Report/ReportHost")[1] }
  let(:report_item1) { report_host1.xpath("ReportItem")[0] }
  let(:report_item2) { report_host2.xpath("ReportItem")[1] }

  let(:host1_item2_description) { "The remote Windows host is affected by the following vulnerabilities :

  - Multiple remote code execution vulnerabilities exist in     Microsoft Server Message Block 1.0 (SMBv1) due to     improper handling of certain requests. An     unauthenticated, remote attacker can exploit these     vulnerabilities, via a specially crafted packet, to     execute arbitrary code. (CVE-2017-0143, CVE-2017-0144,     CVE-2017-0145, CVE-2017-0146, CVE-2017-0148)

  - An information disclosure vulnerability exists in     Microsoft Server Message Block 1.0 (SMBv1) due to     improper handling of certain requests. An     unauthenticated, remote attacker can exploit this, via a     specially crafted packet, to disclose sensitive     information. (CVE-2017-0147)

ETERNALBLUE, ETERNALCHAMPION, ETERNALROMANCE, and ETERNALSYNERGY are four of multiple Equation Group vulnerabilities and exploits disclosed on 2017/04/14 by a group known as the Shadow Brokers. WannaCry / WannaCrypt is a ransomware program utilizing the ETERNALBLUE exploit, and EternalRocks is a worm that utilizes seven Equation Group vulnerabilities. Petya is a ransomware program that first utilizes CVE-2017-0199, a vulnerability in Microsoft Office, and then spreads via ETERNALBLUE." }

let(:host1_item2_solution) { "Microsoft has released a set of patches for Windows Vista, 2008, 7, 2008 R2, 2012, 8.1, RT 8.1, 2012 R2, 10, and 2016. Microsoft has also released emergency patches for Windows operating systems that are no longer supported, including Windows XP, 2003, and 8.

For unsupported Windows operating systems, e.g. Windows XP, Microsoft recommends that users discontinue the use of SMBv1. SMBv1 lacks security features that were included in later SMB versions. SMBv1 can be disabled by following the vendor instructions provided in Microsoft KB2696547. Additionally, US-CERT recommends that users block SMB directly by blocking TCP port 445 on all network boundary devices. For SMB over the NetBIOS API, block TCP ports 137 / 139 and UDP ports 137 / 138 on all network boundary devices." }

let(:host1_item2_plugin_output) { "Information about this scan : \n\nNessus version : 7.1.0\nPlugin feed version : 201806032020\nScanner edition used : Nessus\nScan type : Normal\nScan policy used : WannaCry Ransomware\nScanner IP : 192.0.2.1\n\nWARNING : No port scanner was enabled during the scan. This may\nlead to incomplete results.\n\nPort range : default\nThorough tests : no\nExperimental tests : no\nParanoia level : 1\nReport verbosity : 1\nSafe checks : yes\nOptimize the test : yes\nCredentialed checks : no\nPatch management checks : None\nCGI scanning : disabled\nWeb application tests : disabled\nMax hosts : 120\nMax checks : 5\nRecv timeout : 5\nBackports : None\nAllow post-scan editing: Yes\nScan Start Date : 2018/6/4 12:57 CEST\nScan duration : 53 sec\n" }

let(:host1_item2_synopsis) { "The remote Windows host is affected by multiple vulnerabilities." }
let(:host1_item2_see_also) {
"https://technet.microsoft.com/library/security/MS17-010
http://www.nessus.org/u?321523eb
http://www.nessus.org/u?7bec1941
http://www.nessus.org/u?d9f569cf
https://blogs.technet.microsoft.com/filecab/2016/09/16/stop-using-smb1/
https://support.microsoft.com/en-us/kb/2696547
http://www.nessus.org/u?8dcab5e4
http://www.nessus.org/u?36fd3072
http://www.nessus.org/u?4c7e0cf3
https://github.com/stamparm/EternalRocks/
http://www.nessus.org/u?59db5b5b" }

  # check for class methods
  it { expect(Boskop::Nessus::ReportItem.respond_to? :new).to be_truthy}

  describe "without option :report_item" do
    subject { Boskop::Nessus::ReportItem.new() }
    it "::new raise an KeyError" do
      expect { Boskop::Nessus::ReportItem.new() }.to raise_error(KeyError)   
    end
  end

  describe "with invalid report_item" do
    subject { Boskop::Nessus::ReportItem.new(report_item: nil) }
    it { expect(subject).not_to be_valid }
  end

  describe "with valid xml report_item2" do
    subject { Boskop::Nessus::ReportItem.new(report_item: report_item2) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::Nessus::ReportItem }
    it { expect(subject).to be_valid }
    it { expect(subject.oid).to eq("nessus:97833") }
    it { expect(subject.family).to eq("Windows") }
    it { expect(subject.description).to eq(host1_item2_description) }
    it { expect(subject.name).to eq("MS17-010: Security Update for Microsoft Windows SMB Server (4013389) (ETERNALBLUE) (ETERNALCHAMPION) (ETERNALROMANCE) (ETERNALSYNERGY) (WannaCry) (EternalRocks) (Petya) (uncredentialed check)") }
    it { expect(subject.cvss_base).to eq("10.0") }
    it { expect(subject.threat).to eq("Critical") }
    it { expect(subject.severity).to eq("10.0") }
    it { expect(subject.cves).to contain_exactly( "CVE-2017-0143", "CVE-2017-0144",
                                                  "CVE-2017-0145", "CVE-2017-0146",
                                                  "CVE-2017-0147", "CVE-2017-0148") }
    it { expect(subject.bids).to contain_exactly( "96703", "96704", "96705",
                                                  "96706", "96707", "96709") }
    it { expect(subject.xrefs).to contain_exactly( 
           "OSVDB:153673", "OSVDB:153674",
           "OSVDB:153675", "OSVDB:153676",
           "OSVDB:153677", "OSVDB:153678",
           "OSVDB:155620", "OSVDB:155634",
           "OSVDB:155635", "EDB-ID:41891",
           "EDB-ID:41987", "MSFT:MS17-010",
           "IAVA:2017-A-0065", "MSKB:4012212",
           "MSKB:4012213", "MSKB:4012214",
           "MSKB:4012215", "MSKB:4012216",
           "MSKB:4012217", "MSKB:4012606",
           "MSKB:4013198", "MSKB:4013429",
           "MSKB:4012598" ) }
    it { expect(subject.synopsis).to eq(host1_item2_synopsis) }
    it { expect(subject.see_also).to eq(host1_item2_see_also) }
    it { expect(subject.solution).to eq( host1_item2_solution) }


    it { expect(subject.vuln_publication_date).to eq("2017/03/14") }
    it { expect(subject.patch_publication_date).to eq("2017/03/14") }
    it { expect(subject.exploit_available).to eq("true") }
    it { expect(subject.exploited_by_malware).to eq("true") }
    
    it { expect(subject.attributes).to include(
           nvt: "nessus:97833",
           description: host1_item2_description,
           ) }
    it { expect(subject.notes).to include(
        synopsis: host1_item2_synopsis,
        description: host1_item2_description,
        see_also: host1_item2_see_also,
        solution: host1_item2_solution,
        vuln_publication_date: "2017/03/14",
        patch_publication_date: "2017/03/14",
        exploit_available: "true",
        exploited_by_malware: "true"
    )}
  end

  describe "within report_item1" do
    subject { Boskop::Nessus::ReportItem.new(report_item: report_item1) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::Nessus::ReportItem }
    it { expect(subject).to be_valid }
    it { expect(subject.oid).to eq("nessus:19506") }
    it { expect(subject.family).to eq("Settings") }
    it { expect(subject.threat).to eq("None") }
    it { expect(subject.solution).to eq("n/a") }
    it { expect(subject.synopsis).to eq("This plugin displays information about the Nessus scan.") }
    it { expect(subject.plugin_output).to eq( host1_item2_plugin_output) }
    it { 
      expect(subject.attributes).to include(
        nvt: "nessus:19506",
        family: "Settings",
        solution: "n/a",
        threat: "None"
    )}
  end

end
