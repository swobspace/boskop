require 'rails_helper'
  
RSpec.describe Boskop::Nessus::XML do
  let!(:testpdf) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.pdf') }
  let!(:invalidxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-invalid.xml') }

  # check for class methods
  it { expect(Boskop::Nessus::XML.respond_to? :new).to be_truthy}

  describe "without option :file" do
    subject { Boskop::Nessus::XML.new() }
    it "::new raise an KeyError" do
      expect { Boskop::Nessus::XML.new() }.to raise_error(KeyError)   
    end
  end

  describe "with wrong file format" do
    subject { Boskop::Nessus::XML.new(file: testpdf) }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with invalid xml file" do
    subject { Boskop::Nessus::XML.new(file: invalidxml) }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with empty input file" do
    subject { Boskop::Nessus::XML.new(file: "") }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with valid input xml file" do
    let(:nessusxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'cry-nessus.xml') }
    subject { Boskop::Nessus::XML.new(file: nessusxml) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :file).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject.respond_to? :error_message).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::Nessus::XML }
    it { expect(subject).to be_valid }
    it { expect(subject.all? {|o| o.kind_of? Boskop::Nessus::ReportHost}).to be_truthy }
    it { expect(subject.host_reports.first).to be_a_kind_of Boskop::Nessus::ReportHost }
  end

end
