require 'rails_helper'

RSpec.shared_examples "a host query" do
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

RSpec.describe HostQuery do
  include_context "host variables"
  let(:all_hosts) { Host.left_outer_joins(:network_interfaces, :location, :host_category, :operating_system, :merkmale).distinct.order("name asc") }


  # check for class methods
  it { expect(HostQuery.respond_to? :new).to be_truthy}

  it "raise an ArgumentError" do
  expect {
    HostQuery.new
  }.to raise_error(ArgumentError)
  end

 # check for instance methods
  describe "instance methods" do
    subject { HostQuery.new(all_hosts) }
    it { expect(subject.respond_to? :all).to be_truthy}
    it { expect(subject.respond_to? :find_each).to be_truthy}
    it { expect(subject.respond_to? :include?).to be_truthy }
  end

 context "with unknown option :fasel" do
    subject { HostQuery.new(all_hosts, {fasel: 'blubb'}) }
    describe "#all" do
      it "raises a argument error" do
        expect { subject.all }.to raise_error(ArgumentError)
      end
    end
  end

  context "with :name" do
    subject { HostQuery.new(all_hosts, {name: 'MyPc'}) }
    before(:each) do
      @matching = [pc2, pc3, pc5]
      @nonmatching = [vpngw, nas]
    end
    it_behaves_like "a host query"
  end # search :name

  context "with :limit = 3" do
    subject { HostQuery.new(all_hosts, {limit: "3"}) }
    before(:each) do
      @matching = [nas, pc2, pc3]
      @nonmatching = [] # does not work
    end
    it_behaves_like "a host query"
  end # search :limit = 3

  context "with :limit = 0" do
    subject { HostQuery.new(all_hosts, {limit: "0"}) }
    before(:each) do
      @matching = [nas, pc2, pc3, pc5, vpngw]
      @nonmatching = []
    end
    it_behaves_like "a host query"
  end # search :limit = 0

  context "with :description" do
    subject { HostQuery.new(all_hosts, {description: 'WorkStation'}) }
    before(:each) do
      @matching = [pc2, pc3, pc5]
      @nonmatching = [nas, vpngw]
    end
    it_behaves_like "a host query"
  end # search :description

  context "with :operating_system" do
    subject { HostQuery.new(all_hosts, {operating_system: 'ummyO'}) }
    before(:each) do
      @matching = [pc2, nas]
      @nonmatching = [pc3, pc5, vpngw]
    end
    it_behaves_like "a host query"
  end # search :operating_system

  context "with eol: true" do
    subject { HostQuery.new(all_hosts, {eol: true}) }
    before(:each) do
      @matching = [pc2, nas]
      @nonmatching = [pc3, pc5, vpngw]
    end
    it_behaves_like "a host query"
  end # search :operating_system

  context "with :cpe" do
    subject { HostQuery.new(all_hosts, {cpe: 'WindowS_7'}) }
    before(:each) do
      @matching = [pc2, pc3]
      @nonmatching = [nas, pc5, vpngw]
    end
    it_behaves_like "a host query"
  end # search :cpe

  context "with :raw_os" do
    subject { HostQuery.new(all_hosts, {raw_os: 'windows 7 PROFessional'}) }
    before(:each) do
      @matching = [pc2, pc3]
      @nonmatching = [nas, pc5, vpngw]
    end
    it_behaves_like "a host query"
  end # search :raw_os

  context "with :domain_dns" do
    subject { HostQuery.new(all_hosts, {domain_dns: 'MY.example.net'}) }
    before(:each) do
      @matching = [pc2, pc3, pc5, nas]
      @nonmatching = [vpngw]
    end
    it_behaves_like "a host query"
  end # search :domain_dns

  context "with :fqdn" do
    subject { HostQuery.new(all_hosts, {fqdn: 'pC005'}) }
    before(:each) do
      @matching = [pc5]
      @nonmatching = [nas, pc2, pc3, vpngw]
    end
    it_behaves_like "a host query"
  end # search :fqdn

  context "with :workgroup" do
    subject { HostQuery.new(all_hosts, {workgroup: 'My'}) }
    before(:each) do
      @matching = [nas, pc2, pc3, pc5]
      @nonmatching = [vpngw]
    end
    it_behaves_like "a host query"
  end # search :workgroup

  context "with :mac" do
    subject { HostQuery.new(all_hosts, {mac: '00:84:ED'}) }
    before(:each) do
      @matching = [nas, pc2, pc3, pc5]
      @nonmatching = [vpngw]
    end
    it_behaves_like "a host query"
  end # search :mac

  context "with :oui_vendor" do
    let!(:macprefix) { FactoryBot.create(:mac_prefix, oui: '0084ED', vendor: 'Gnadenlos unlimited') }
    subject { HostQuery.new(all_hosts, {oui_vendor: 'gnadenlos'}) }
    before(:each) do
      @matching = [nas, pc2, pc3, pc5]
      @nonmatching = [vpngw]
    end
    it_behaves_like "a host query"
  end # search :oui_vendor

  context "with :serial" do
    subject { HostQuery.new(all_hosts, {serial: 'XXX778'}) }
    before(:each) do
      @matching = [pc2, pc3]
      @nonmatching = [vpngw, nas, pc5]
    end
    it_behaves_like "a host query"
  end # search :serial

  context "with :uuid" do
    subject { HostQuery.new(all_hosts, {uuid: 'D4618E67'}) }
    before(:each) do
      @matching = [nas]
      @nonmatching = [vpngw, pc2, pc3, pc5]
    end
    it_behaves_like "a host query"
  end # search :uuid

  context "with :vendor" do
    subject { HostQuery.new(all_hosts, {vendor: 'DELL'}) }
    before(:each) do
      @matching = [pc2, pc3, pc5]
      @nonmatching = [vpngw, nas]
    end
    it_behaves_like "a host query"
  end # search :vendor

  context "with :product" do
    subject { HostQuery.new(all_hosts, {product: '7010'}) }
    before(:each) do
      @matching = [pc2, pc3]
      @nonmatching = [vpngw, nas, pc5]
    end
    it_behaves_like "a host query"
  end # search :product

  context "with :warranty_start" do
    subject { HostQuery.new(all_hosts, {warranty_start: '2017-03'}) }
    before(:each) do
      @matching = [pc2, pc3]
      @nonmatching = [vpngw, nas, pc5]
    end
    it_behaves_like "a host query"
  end # search :product

  context "with :warranty_start from-until" do
    subject { HostQuery.new(all_hosts, {warranty_start_from: '2017-03-01', warranty_start_until: '2017-03-01'}) }
    before(:each) do
      @matching = [pc2, pc3]
      @nonmatching = [vpngw, nas, pc5]
    end
    it_behaves_like "a host query"
  end # search :product

  context "with :ip as string match" do
    subject { HostQuery.new(all_hosts, {ip: '198.51.100'}) }
    before(:each) do
      @matching = [nas, pc2, pc3, pc5]
      @nonmatching = [vpngw]
    end
    it_behaves_like "a host query"
  end # search :ip string match

  context "with :ip as subnet" do
    subject { HostQuery.new(all_hosts, {ip: '198.51.100.0/26'}) }
    before(:each) do
      @matching = [nas, pc2]
      @nonmatching = [vpngw, pc3, pc5]
    end
    it_behaves_like "a host query"
  end # search :ip subnet match

  context "with :lastseen" do
    subject { HostQuery.new(all_hosts, {lastseen: Date.today.to_s[0,7]}) }
    before(:each) do
      @matching = [nas, pc2, pc3]
      @nonmatching = [vpngw, pc5]
    end
    it_behaves_like "a host query"
  end # search :lastseen

  context "with :created_at" do
    subject { HostQuery.new(all_hosts, {created_at: Date.today.to_s[0,7]}) }
    before(:each) do
      @matching = [pc2, pc3, pc5, vpngw]
      @nonmatching = [nas]
    end
    it_behaves_like "a host query"
  end # search :lastseen


  context "with :older" do
    subject { HostQuery.new(all_hosts, {older: 2.weeks.before(Date.today)}) }
    before(:each) do
      @matching = [vpngw, pc5]
      @nonmatching = [nas, pc2, pc3]
    end
    it_behaves_like "a host query"
  end # search :older

  context "with :newer" do
    subject { HostQuery.new(all_hosts, {newer: 1.day.before(Date.today)}) }
    before(:each) do
      @matching = [nas, pc2, pc3]
      @nonmatching = [vpngw, pc5]
    end
    it_behaves_like "a host query"
  end # search :newer

  context "with :current" do
    subject { HostQuery.new(all_hosts, {current: 1}) }
    before(:each) do
      @matching = [nas, vpngw, pc2, pc3]
      @nonmatching = [pc5]
    end
    it_behaves_like "a host query"
  end # search :current

  context "with :host_category" do
    subject { HostQuery.new(all_hosts, {host_category: 'inu'}) }
    before(:each) do
      @matching = [vpngw]
      @nonmatching = [pc5, nas, pc2, pc3]
    end
    it_behaves_like "a host query"
  end # search :host_category

  context "with :lid" do
    subject { HostQuery.new(all_hosts, {lid: 'PARIS'}) }
    before(:each) do
      @matching = [nas]
      @nonmatching = [pc5, vpngw, pc2, pc3]
    end
    it_behaves_like "a host query"
  end # search :lid

  context "with multiple lid (String)" do
    subject { HostQuery.new(all_hosts, {lid: 'BER, PARIS'}) }
    before(:each) do
      @matching = [nas, vpngw, pc5]
      @nonmatching = [pc2, pc3]
    end
    it_behaves_like "a host query"
  end # search multiple :lid (String)

  context "with multiple lid (Array)" do
    subject { HostQuery.new(all_hosts, {lid: ['BER', 'PARIS']}) }
    before(:each) do
      @matching = [nas, vpngw, pc5]
      @nonmatching = [pc2, pc3]
    end
    it_behaves_like "a host query"
  end # search multiple :lid (Array)

  context "with :merkmal_responsible" do
    let(:merkmalklasse1) { FactoryBot.create(:merkmalklasse,
      name: 'Responsible',
      tag: 'responsible',
      format: 'string',
      for_object: 'Host',
      visible: ['index', '']
    )}
    let(:merkmalklasse2) { FactoryBot.create(:merkmalklasse,
      name: 'NextStep',
      tag: 'next',
      format: 'string',
      for_object: 'Host',
      visible: ['index', '']
    )}
    let!(:merkmal1) { FactoryBot.create(:merkmal, 
      merkmalfor: nas,
      merkmalklasse: merkmalklasse1,
      value: 'Gandalf'
    )}
    let!(:merkmal2) { FactoryBot.create(:merkmal, 
      merkmalfor: nas,
      merkmalklasse: merkmalklasse2,
      value: 'Replace it'
    )}
    subject { HostQuery.new(all_hosts, {merkmal_responsible: 'gAnDalf'}) }
    before(:each) do
      @matching = [nas]
      @nonmatching = [pc2, pc3, pc5, vpngw]
    end
    it_behaves_like "a host query"

    describe "deliver exactly one result (clean join)" do
      # search for one host, but not for merkmal
      subject { HostQuery.new(all_hosts, {name: 'NAS'}) }
      it { expect(subject.all).to contain_exactly(nas) }
      it { expect(subject.all.count).to eq(1) }
    end
  end # search :merkmal_responsible

  context "with :merkmal_doesnotexist" do
    subject { HostQuery.new(all_hosts, {merkmal_doesnotexist: 'Nonsense'}) }
    describe "#all" do
      it "raise an error" do
        expect { subject.all }.to raise_error(ArgumentError)
      end
    end
  end # search :merkmal_doesnotexist

  describe "#all" do
    context "with search: 'nas'" do
      subject { HostQuery.new(all_hosts, {search: 'nas'}) }
      it { expect(subject.all).to contain_exactly(nas) }
    end
    context "with search: '198.51.100'" do
      subject { HostQuery.new(all_hosts, {search: '198.51.100'}) }
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3, pc5) }
    end
    context "with search: '198.51.100.0/26'" do
      subject { HostQuery.new(all_hosts, {search: '198.51.100.0/26'}) }
      it { expect(subject.all).to contain_exactly(nas, pc2) }
    end
    context "with search: #{Date.today.to_s[0,7]}" do
      subject { HostQuery.new(all_hosts, {search: Date.today.to_s[0,7]}) }
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3) }
    end
    context "with search: 'linux'" do
      subject { HostQuery.new(all_hosts, {search: 'firewall'}) }
      it { expect(subject.all).to contain_exactly(vpngw) }
    end
    context "with search: 'PariS'" do
      subject { HostQuery.new(all_hosts, {search: 'PariS'}) }
      it { expect(subject.all).to contain_exactly(nas) }
    end
  end

  describe "with vuln_risk" do
  let!(:h1) { FactoryBot.create(:host, vuln_risk: 'Critical')}
  let!(:h2) { FactoryBot.create(:host, vuln_risk: 'High')}
  let!(:h3) { FactoryBot.create(:host, vuln_risk: 'Medium')}
  let!(:h4) { FactoryBot.create(:host, vuln_risk: 'Low')}
  let!(:h5) { FactoryBot.create(:host, vuln_risk: 'High',
                                    lastseen: 5.weeks.before(Date.today))}

    context "with vuln_risk: higher" do
      subject { HostQuery.new(all_hosts, {vuln_risk: 'higher'}) }
      before(:each) do
        @matching = [h1, h2, h5]
        @nonmatching = [h3, h4]
      end
      it_behaves_like "a host query"
    end # search :vuln_risk higher

    context "with vuln_risk: 'High'" do
      subject { HostQuery.new(all_hosts, {vuln_risk: 'high'}) }
      before(:each) do
        @matching = [h2, h5]
        @nonmatching = [h1, h3, h4]
      end
      it_behaves_like "a host query"
    end # search :vuln_risk High

    context "with search string 'High'" do
      subject { HostQuery.new(all_hosts, {search: 'high'}) }
      before(:each) do
        @matching = [h2, h5]
        @nonmatching = [h1, h3, h4]
      end
      it_behaves_like "a host query"
    end
  end # vuln_risk
end
