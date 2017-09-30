require 'rails_helper'
  
RSpec.describe Boskop::OpenVAS::Result do
  let(:xmlfile) {"/home/wob/Projects/boskop/spec/fixtures/files/openvas-wobnet-anon.xml"}
  let(:xmldoc)  { File.open(xmlfile) { |f| Nokogiri::XML(f) } }
  let(:result1) { xmldoc.xpath("//report/results/result").first }
  let(:result2) { xmldoc.xpath("//report/results/result").last }
  

  # check for class methods
  it { expect(Boskop::OpenVAS::Result.respond_to? :new).to be_truthy}

  describe "without option :result" do
    subject { Boskop::OpenVAS::Result.new() }
    it "::new raise an KeyError" do
      expect { Boskop::OpenVAS::Result.new() }.to raise_error(KeyError)   
    end
  end

  describe "with invalid result" do
    subject { Boskop::OpenVAS::Result.new(result: nil) }
    it { expect(subject).not_to be_valid }
  end

  describe "with valid xml result2" do
    subject { Boskop::OpenVAS::Result.new(result: result2) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::OpenVAS::Result }
    it { expect(subject).to be_valid }
    it { expect(subject.host).to eq('127.0.0.1') }
    it { expect(subject.lastseen.to_s).to match(/\A2017-09-26T15:49:12Z/) }
    it { expect(subject.name).to eq("Microsoft Windows SMB Server Multiple Vulnerabilities-Remote (4013389)") }
    it { expect(subject.family).to eq("Windows : Microsoft Bulletins") }
    it { expect(subject.severity).to eq("9.3") }
    it { expect(subject.threat).to eq("High") }
    it { expect(subject.cvss_base).to eq("9.3") }
    it { expect(subject.cves).to contain_exactly("CVE-2017-0143", "CVE-2017-0144", "CVE-2017-0145", "CVE-2017-0146", "CVE-2017-0147", "CVE-2017-0148") }
    it { expect(subject.nvt).to eq("1.3.6.1.4.1.25623.1.0.810676") }
    it { expect(subject.bids).to contain_exactly("96703", "96704", "96705", "96707", "96709", "96706") }
    it { expect(subject.tags).to be_a_kind_of Hash }
    it { expect(subject.tags).to include(
           "cvss_base_vector"=>"AV:N/AC:M/Au:N/C:C/I:C/A:C",
           "summary"=>"This host is missing a critical security\n  update according to Microsoft Bulletin MS17-010.",
           "solution_type"=>"VendorFix", "qod_type"=>"remote_active"
       )}
    it { expect(subject.xrefs).to contain_exactly("URL:https://support.microsoft.com/en-in/kb/4013078", "URL:https://technet.microsoft.com/library/security/MS17-010", "URL:https://github.com/rapid7/metasploit-framework/pull/8167/files") }
    it { expect(subject.certs).to contain_exactly(
                                   {id: "CB-K17/0435", type: "CERT-Bund"},
                                   {id: "DFN-CERT-2017-0448", type: "DFN-CERT"}) }
    it { expect(subject.attributes).to include(
           lastseen: '2017-09-26T15:49:12Z',
           host: '127.0.0.1',
           name: 'Microsoft Windows SMB Server Multiple Vulnerabilities-Remote (4013389)',
           family: 'Windows : Microsoft Bulletins',
           cvss_base: '9.3',
           threat: 'High',
           severity: '9.3',
           cves: ["CVE-2017-0143", "CVE-2017-0144", "CVE-2017-0145", "CVE-2017-0146", "CVE-2017-0147", "CVE-2017-0148"],
           nvt: '1.3.6.1.4.1.25623.1.0.810676',
           bids: ["96703", "96704", "96705", "96707", "96709", "96706"],
           xrefs: ["URL:https://support.microsoft.com/en-in/kb/4013078", "URL:https://technet.microsoft.com/library/security/MS17-010", "URL:https://github.com/rapid7/metasploit-framework/pull/8167/files"],
           certs: [{:id=>"CB-K17/0435", :type=>"CERT-Bund"}, {:id=>"DFN-CERT-2017-0448", :type=>"DFN-CERT"}],
           ) }
    it { expect(subject.attributes[:tags]).to include(
           "cvss_base_vector"=>"AV:N/AC:M/Au:N/C:C/I:C/A:C",
           "summary"=>"This host is missing a critical security\n  update according to Microsoft Bulletin MS17-010.",
           "solution_type"=>"VendorFix", "qod_type"=>"remote_active"
       )}
    it { pp subject.attributes.keys }
  end

  describe "with valid xml result1" do
    subject { Boskop::OpenVAS::Result.new(result: result1) }

    it { expect(subject.nvt).to eq("1.3.6.1.4.1.25623.1.0.103674") }
    it { expect(subject.cves).to contain_exactly() }
    it { expect(subject.bids).to contain_exactly() }
    it { expect(subject.xrefs).to contain_exactly() }
    it { pp subject.attributes }
  end
end
