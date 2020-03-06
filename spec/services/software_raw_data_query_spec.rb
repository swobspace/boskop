require 'rails_helper'

RSpec.shared_examples "a software_raw_data query" do
  describe "#all" do
    it { expect(subject.all).to contain_exactly(*@matching) }
  end
  describe "#find_each" do
    it "iterates over matching events" do
      a = []
      subject.find_each do |act|
        a << act
      end
      expect(a).to contain_exactly(*@matching)
    end
  end
  describe "#include?" do
    it "includes only matching events" do
      @matching.each do |ma|
        expect(subject.include?(ma)).to be_truthy
      end
      @nonmatching.each do |noma|
        expect(subject.include?(noma)).to be_falsey
      end
    end
  end
end

RSpec.describe SoftwareRawDataQuery do
  include_context "software_raw_data variables"
  let(:all_software_raw_data) { SoftwareRawDatum.all.order("name asc") }

  # check for class methods
  it { expect(SoftwareRawDataQuery.respond_to? :new).to be_truthy}

  it "raise an ArgumentError" do
  expect {
    SoftwareRawDataQuery.new
  }.to raise_error(ArgumentError)
  end

 # check for instance methods
  describe "instance methods" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data) }
    it { expect(subject.respond_to? :all).to be_truthy}
    it { expect(subject.respond_to? :find_each).to be_truthy}
    it { expect(subject.respond_to? :include?).to be_truthy }
  end

 context "with unknown option :fasel" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {fasel: 'blubb'}) }
    describe "#all" do
      it "raises a argument error" do
        expect { subject.all }.to raise_error(ArgumentError)
      end
    end
  end

  context "with :name" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {name: 'visual studio'}) }
    before(:each) do
      @matching = [raw1, raw2]
      @nonmatching = [raw3, raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :name

  context "with :search for name" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {search: 'visual studio'}) }
    before(:each) do
      @matching = [raw1, raw2]
      @nonmatching = [raw3, raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :search for name

  context "with :lastseen" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {lastseen: '2020-03'}) }
    before(:each) do
      @matching = [raw1, raw2, raw3]
      @nonmatching = [raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :lastseen

  context "with :search for lastseen" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {search: '2020-03'}) }
    before(:each) do
      @matching = [raw1, raw2, raw3]
      @nonmatching = [raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :search for lastseen

  context "with :created_at" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {created_at: Date.today.to_s}) }
    before(:each) do
      @matching = [raw1, raw2, raw3, raw4]
      @nonmatching = [raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :created_at

  context "with :newer" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {newer: '2020-03-01'}) }
    before(:each) do
      @matching = [raw1, raw2, raw3]
      @nonmatching = [raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :newer

  context "with :older" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {older: '2020-03-01'}) }
    before(:each) do
      @matching = [raw1, raw4, raw5]
      @nonmatching = [raw2, raw3]
    end
    it_behaves_like "a software_raw_data query"
  end # :older

  context "with :pattern" do
    let(:pattern) {{ "name" => '.*studio.*(runtime|laufzeit)', "vendor" => 'microsoft' }}
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {pattern: pattern}) }
    before(:each) do
      @matching = [raw1, raw2]
      @nonmatching = [raw3, raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :pattern

  context "with :software_id" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {software_id: sw1.id}) }
    before(:each) do
      @matching = [raw1]
      @nonmatching = [raw2, raw3, raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :software_id

  context "with software_id: nil" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {software_id: nil}) }
    before(:each) do
      @matching = [raw3, raw4, raw5]
      @nonmatching = [raw1, raw2]
    end
    it_behaves_like "a software_raw_data query"
  end # :software_id

  context "with no_software_id: true" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {no_software_id: true}) }
    before(:each) do
      @matching = [raw3, raw4, raw5]
      @nonmatching = [raw1, raw2]
    end
    it_behaves_like "a software_raw_data query"
  end # :software_id


  context "with :software_id and :use_pattern" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {use_pattern: true, software_id: sw1.id}) }
    before(:each) do
      @matching = [raw1, raw2]
      @nonmatching = [raw3, raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
  end # :software_id

  context "with :software_id, :use_pattern and empty software pattern" do
    subject { SoftwareRawDataQuery.new(all_software_raw_data, {use_pattern: true, software_id: sw2.id}) }
    before(:each) do
      @matching = []
      @nonmatching = [raw1, raw2, raw3, raw4, raw5]
    end
    it_behaves_like "a software_raw_data query"
    it { expect(sw2.pattern).to be_empty }
  end # :software_id


end
