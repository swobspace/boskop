require 'rails_helper'
  
RSpec.describe Boskop::NMAP::XML do
  let!(:testpdf) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.pdf') }

  # check for class methods
  it { expect(Boskop::NMAP::XML.respond_to? :new).to be_truthy}

  describe "without option :file" do
    subject { Boskop::NMAP::XML.new() }
    it "::new raise an KeyError" do
      expect { Boskop::NMAP::XML.new() }.to raise_error(KeyError)   
    end
  end

  describe "with invalid input file" do
    subject { Boskop::NMAP::XML.new(file: testpdf) }
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
  end

  describe "with valid input xml file and script_data" do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'smb-os-discovery-42.xml') }
    subject { Boskop::NMAP::XML.new(file: nmapxml) }

    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::NMAP::XML }
    it { expect(subject).to be_valid }
    it { expect(subject.all_hosts.first).to be_a_kind_of Boskop::NMAP::Host }
  end

end
