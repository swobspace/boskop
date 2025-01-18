require 'rails_helper'
  
RSpec.describe Boskop::OpenVAS::XML do
  let!(:testpdf) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.pdf') }
  let!(:invalidxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'nmap-invalid.xml') }

  # check for class methods
  it { expect(Boskop::OpenVAS::XML.respond_to? :new).to be_truthy}

  describe "without option :file" do
    subject { Boskop::OpenVAS::XML.new() }
    it "::new raise an KeyError" do
      expect { Boskop::OpenVAS::XML.new() }.to raise_error(KeyError)   
    end
  end

  describe "with wrong file format" do
    subject { Boskop::OpenVAS::XML.new(file: testpdf) }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with invalid xml file" do
    subject { Boskop::OpenVAS::XML.new(file: invalidxml) }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with empty input file" do
    subject { Boskop::OpenVAS::XML.new(file: "") }
    it { expect(subject).not_to be_valid }
    it { expect(subject.error_message.present?).to be_truthy }
  end

  describe "with valid input xml file" do
    let(:openvas) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'openvas-wobnet-anon.xml') }
    subject { Boskop::OpenVAS::XML.new(file: openvas) }

    it { expect(subject.respond_to? :options).to be_truthy}
    it { expect(subject.respond_to? :file).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject.respond_to? :error_message).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::OpenVAS::XML }
    it { expect(subject).to be_valid }
    it { expect(subject.starttime.localtime.to_s).to match(/\A2017-09-26 17:43:04/) }
    it { expect(subject.all? {|o| o.kind_of? Boskop::OpenVAS::Result}).to be_truthy }
    it { expect(subject.omp_version).to eq("7.0")  }
    it { expect(subject.report_format).to eq("Anonymous XML")  }
    it { expect(subject.results.first).to be_a_kind_of Boskop::OpenVAS::Result }
  end

end
