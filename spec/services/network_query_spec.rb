require 'rails_helper'

RSpec.shared_examples "a network query" do
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

RSpec.describe NetworkQuery do
  include_context "network variables"
  let(:networks) { Network.left_outer_joins(:location, :merkmale).distinct }


  # check for class methods
  it { expect(NetworkQuery.respond_to? :new).to be_truthy}

  it "raise an ArgumentError" do
  expect {
    NetworkQuery.new
  }.to raise_error(ArgumentError)
  end

 # check for instance methods
  describe "instance methods" do
    subject { NetworkQuery.new(networks) }
    it { expect(subject.respond_to? :all).to be_truthy}
    it { expect(subject.respond_to? :find_each).to be_truthy}
    it { expect(subject.respond_to? :include?).to be_truthy }
  end

 context "with unknown option :fasel" do
    subject { NetworkQuery.new(networks, {fasel: 'blubb'}) }
    describe "#all" do
      it "raises a argument error" do
        expect { subject.all }.to raise_error(ArgumentError)
      end
    end
  end

  context "with :limit = 2" do
    subject { NetworkQuery.new(networks, {limit: "2"}) }
    before(:each) do
      @matching = [net1, net2]
      @nonmatching = [] # does not work
    end
    it_behaves_like "a network query"
  end # search :limit = 2

  context "with :limit = 0" do
    subject { NetworkQuery.new(networks, {limit: "0"}) }
    before(:each) do
      @matching = [net1, net2, net3]
      @nonmatching = []
    end
    it_behaves_like "a network query"
  end # search :limit = 0

  context "with :description" do
    subject { NetworkQuery.new(networks, {description: 'intern'}) }
    before(:each) do
      @matching = [net1]
      @nonmatching = [net2, net2]
    end
    it_behaves_like "a network query"
  end # search :description

  context "with :netzwerk as string match" do
    subject { NetworkQuery.new(networks, {netzwerk: '198.51.100'}) }
    before(:each) do
      @matching = [net1]
      @nonmatching = [net2,net3]
    end
    it_behaves_like "a network query"
  end # search :ip string match

  context "with :network" do
    subject { NetworkQuery.new(networks, {ip: '198.51.100.0/24'}) }
    before(:each) do
      @matching = [net1]
      @nonmatching = [net2,net3]
    end
    it_behaves_like "a network query"
  end # search :ip subnet match

  context "with :network and :subset " do
    subject { NetworkQuery.new(networks, {network: '192.0.2.63/32', is_subset: true}) }
    before(:each) do
      @matching = [net2]
      @nonmatching = [net1,net3]
    end
    it_behaves_like "a network query"
  end # search list of :ip match

  context "with :lid" do
    subject { NetworkQuery.new(networks, {lid: 'PARIS'}) }
    before(:each) do
      @matching = [net3]
      @nonmatching = [net1, net2]
    end
    it_behaves_like "a network query"
  end # search :lid

  context "with multiple lid (String)" do
    subject { NetworkQuery.new(networks, {lid: 'BER, PARIS'}) }
    before(:each) do
      @matching = [net1, net3]
      @nonmatching = [net2]
    end
    it_behaves_like "a network query"
  end # search multiple :lid (String)

  context "with multiple lid (Array)" do
    subject { NetworkQuery.new(networks, {lid: ['BER', 'PARIS']}) }
    before(:each) do
      @matching = [net1, net3]
      @nonmatching = [net2]
    end
    it_behaves_like "a network query"
  end # search multiple :lid (Array)

  context "with :merkmal_vlan" do
    let(:merkmalklasse1) { FactoryBot.create(:merkmalklasse,
      name: 'VLAN',
      tag: 'vlan',
      format: 'number',
      for_object: 'Network',
      visible: ['index', '']
    )}
    let(:merkmalklasse2) { FactoryBot.create(:merkmalklasse,
      name: 'MPLSRouting',
      tag: 'mpls_routing',
      format: 'string',
      for_object: 'Network',
      visible: ['index', '']
    )}
    let!(:merkmal1) { FactoryBot.create(:merkmal, 
      merkmalfor: net1,
      merkmalklasse: merkmalklasse1,
      value: 10
    )}
    let!(:merkmal2) { FactoryBot.create(:merkmal, 
      merkmalfor: net1,
      merkmalklasse: merkmalklasse2,
      value: 20
    )}
    subject { NetworkQuery.new(networks, {merkmal_vlan: '10'}) }
    before(:each) do
      @matching = [net1]
      @nonmatching = [net2, net3]
    end
    it_behaves_like "a network query"

    describe "deliver exactly one result (clean join)" do
      # search for one network, but not for merkmal
      subject { NetworkQuery.new(networks, {description: 'intern'}) }
      it { expect(subject.all).to contain_exactly(net1) }
      it { expect(subject.all.count).to eq(1) }
    end
  end # search :merkmal_responsible

  context "with :merkmal_doesnotexist" do
    subject { NetworkQuery.new(networks, {merkmal_doesnotexist: 'Nonsense'}) }
    describe "#all" do
      it "raise an error" do
        expect { subject.all }.to raise_error(ArgumentError)
      end
    end
  end # search :merkmal_doesnotexist

  describe "#all" do
    context "with search: 'nas'" do
      subject { NetworkQuery.new(networks, {search: 'BERLIN'}) }
      it { expect(subject.all).to contain_exactly(net1) }
    end
    context "with search: 'PariS'" do
      subject { NetworkQuery.new(networks, {search: 'PariS'}) }
      it { expect(subject.all).to contain_exactly(net2) }
    end
  end

end
