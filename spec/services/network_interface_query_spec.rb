require 'rails_helper'

RSpec.shared_examples "a network_interface query" do
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

RSpec.describe NetworkInterfaceQuery do
  include_context "network_interface variables"
  let(:ifaces) { NetworkInterface.left_outer_joins(host: [ :location ])}

  # check for class methods
  it { expect(NetworkInterfaceQuery.respond_to? :new).to be_truthy}

  it "raise an ArgumentError" do
  expect {
    NetworkInterfaceQuery.new
  }.to raise_error(ArgumentError)
  end

 # check for instance methods
  describe "instance methods" do
    subject { NetworkInterfaceQuery.new(ifaces) }
    it { expect(subject.respond_to? :all).to be_truthy}
    it { expect(subject.respond_to? :find_each).to be_truthy}
    it { expect(subject.respond_to? :include?).to be_truthy }
  end

 context "with unknown option :fasel" do
    subject { NetworkInterfaceQuery.new(ifaces, {fasel: 'blubb'}) }
    describe "#all" do
      it "raises a argument error" do
        expect { subject.all }.to raise_error(ArgumentError)
      end
    end
  end

  context "with :hostname" do
    subject { NetworkInterfaceQuery.new(ifaces, {hostname: 'my.domain'}) }
    before(:each) do
      @matching = [if_host1, if_host2]
      @nonmatching = [if1_host3, if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :hostname

  context "with :limit = 3" do
    subject { NetworkInterfaceQuery.new(ifaces, {limit: "3"}) }
    before(:each) do
      @matching = [if_host1, if_host2, if1_host3]
      @nonmatching = []
    end
    it_behaves_like "a network_interface query"
  end # search :limit

  context "with :limit = 0" do
    subject { NetworkInterfaceQuery.new(ifaces, {limit: "0"}) }
    before(:each) do
      @matching = [if_host1, if_host2, if1_host3, if2_host3]
      @nonmatching = []
    end
    it_behaves_like "a network_interface query"
  end # search :limit

  context "with :ip as string match" do
    subject { NetworkInterfaceQuery.new(ifaces, {ip: '198.51.100'}) }
    before(:each) do
      @matching = [if_host1, if_host2]
      @nonmatching = [if1_host3, if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :ip string match

  context "with :ip as subnet" do
    subject { NetworkInterfaceQuery.new(ifaces, {ip: '198.51.100.0/26'}) }
    before(:each) do
      @matching = [if_host1]
      @nonmatching = [if_host2, if1_host3, if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :ip subnet match

  context "with :mac" do
    subject { NetworkInterfaceQuery.new(ifaces, {mac: '11:22:33:44'}) }
    before(:each) do
      @matching = [if_host1, if_host2]
      @nonmatching = [if1_host3, if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :mac


  context "with :lastseen" do
    subject { NetworkInterfaceQuery.new(ifaces, {lastseen: today[0..6]}) }
    before(:each) do
      @matching = [if_host1]
      @nonmatching = [if_host2, if1_host3, if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :lastseen

  context "with :created_at" do
    subject { NetworkInterfaceQuery.new(ifaces, {created_at: twomonth[0..6]}) }
    before(:each) do
      @matching = [if_host1, if2_host3]
      @nonmatching = [if_host2, if1_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :lastseen

  context "with :at" do
    subject { NetworkInterfaceQuery.new(ifaces, {at: today}) }
    before(:each) do
      @matching = [if_host1]
      @nonmatching = [if_host2, if2_host3, if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :at

  context "with :newer" do
    subject { NetworkInterfaceQuery.new(ifaces, {newer: lastweek}) }
    before(:each) do
      @matching = [if_host1, if_host2, if1_host3]
      @nonmatching = [if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :newer

  context "with :since" do
    subject { NetworkInterfaceQuery.new(ifaces, {since: lastweek}) }
    before(:each) do
      @matching = [if_host1, if_host2, if1_host3]
      @nonmatching = [if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :since

  context "with :older" do
    subject { NetworkInterfaceQuery.new(ifaces, {older: fourweeks}) }
    before(:each) do
      @matching = [if2_host3]
      @nonmatching = [if_host1, if_host2, if1_host3]
    end
    it_behaves_like "a network_interface query"
  end # search :older

  context "with :lid" do
    subject { NetworkInterfaceQuery.new(ifaces, {lid: 'PARIS'}) }
    before(:each) do
      @matching = [if1_host3, if2_host3]
      @nonmatching = [if_host1, if_host2]
    end
    it_behaves_like "a network_interface query"
  end # search :lid

  context "with multiple :lid" do
    subject { NetworkInterfaceQuery.new(ifaces, {lid: 'BER, PARIS'}) }
    before(:each) do
      @matching = [if_host1, if1_host3, if2_host3]
      @nonmatching = [if_host2]
    end
    it_behaves_like "a network_interface query"
  end # search multiple :lid

  context "with :if_description" do
    subject { NetworkInterfaceQuery.new(ifaces, {if_description: 'bbelfas'}) }
    before(:each) do
      @matching = [if_host1]
      @nonmatching = [if_host2, if1_host3, if2_host3]
    end
    it_behaves_like "a network_interface query"
  end # search if_description


  describe "#all" do
    context "with search: 'other.domain'" do
      subject { NetworkInterfaceQuery.new(ifaces, {search: 'other.domain'}) }
      it { expect(subject.all).to contain_exactly(if1_host3, if2_host3)}
    end
    context "with search: '198.51.100'" do
      subject { NetworkInterfaceQuery.new(ifaces, {search: '198.51.100'}) }
      it { expect(subject.all).to contain_exactly(if_host1, if_host2) }
    end
    context "with search: '198.51.100.0/26'" do
      subject { NetworkInterfaceQuery.new(ifaces, {search: '198.51.100.0/26'}) }
      it { expect(subject.all).to contain_exactly(if_host1) }
    end
    context "with search: 11223344" do
      subject { NetworkInterfaceQuery.new(ifaces, {search: '11223344'}) }
      it { expect(subject.all).to contain_exactly(if_host1, if_host2) }
    end
    context "with search: #{Date.today.to_s[0..6]}" do
      subject { NetworkInterfaceQuery.new(ifaces, {search: today[0..6]}) }
      it { expect(subject.all).to contain_exactly(if_host1) }
    end
    context "with search: 'PariS'" do
      subject { NetworkInterfaceQuery.new(ifaces, {search: 'PariS'}) }
      it { expect(subject.all).to contain_exactly(if1_host3, if2_host3) }
    end
    context "with search: 'bbelfas'" do
      subject { NetworkInterfaceQuery.new(ifaces, {search: 'bbelfas'}) }
      it { expect(subject.all).to contain_exactly(if_host1) }
    end
  end
end
