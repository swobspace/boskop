require 'rails_helper'

RSpec.describe HostQuery do
  include_context "host variables"
  let(:all_hosts) { Host.left_outer_joins(:location, :host_category, :operating_system) }


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
    describe "#all" do
      it { expect(subject.all).to contain_exactly(pc2, pc3, pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc2.id, pc3.id, pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_falsey }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :name

  context "with :limit" do
    subject { HostQuery.new(all_hosts, {limit: 3}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc2.id, pc3.id, nas.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { skip "special query and limit doesn work"; expect(subject.include?(pc5)).to be_falsey }
      it { skip "special query and limit doesn work"; expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :limit

  context "with :description" do
    subject { HostQuery.new(all_hosts, {description: 'WorkStation'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(pc2, pc3, pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc2.id, pc3.id, pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_falsey }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :description

  context "with :operating_system" do
    subject { HostQuery.new(all_hosts, {operating_system: 'ummyO'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(pc2, nas) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc2.id, nas.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :operating_system

  context "with eol: true" do
    subject { HostQuery.new(all_hosts, {eol: true}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(pc2, nas) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc2.id, nas.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :operating_system

  context "with :cpe" do
    subject { HostQuery.new(all_hosts, {cpe: 'WindowS_7'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(pc2, pc3) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc2.id, pc3.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_falsey }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :cpe

  context "with :raw_os" do
    subject { HostQuery.new(all_hosts, {raw_os: 'windows 7 PROFessional'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(pc2, pc3) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc2.id, pc3.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_falsey }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :raw_os

  context "with :domain_dns" do
    subject { HostQuery.new(all_hosts, {domain_dns: 'MY.example.net'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3, pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id, pc2.id, pc3.id, pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :domain_dns

  context "with :fqdn" do
    subject { HostQuery.new(all_hosts, {fqdn: 'pC005'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_falsey }
      it { expect(subject.include?(pc2)).to be_falsey }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :fqdn

  context "with :workgroup" do
    subject { HostQuery.new(all_hosts, {workgroup: 'My'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3, pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id, pc2.id, pc3.id, pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :workgroup

  context "with :mac" do
    subject { HostQuery.new(all_hosts, {mac: '00:84:ED'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3, pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id, pc2.id, pc3.id, pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :mac

  context "with :ip as string match" do
    subject { HostQuery.new(all_hosts, {ip: '198.51.100'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3, pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id, pc2.id, pc3.id, pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :ip string match

  context "with :ip as subnet" do
    subject { HostQuery.new(all_hosts, {ip: '198.51.100.0/26'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id, pc2.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :ip subnet match

  context "with :lastseen" do
    subject { HostQuery.new(all_hosts, {lastseen: Date.today.to_s[0,7]}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id, pc2.id, pc3.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :lastseen

  context "with :older" do
    subject { HostQuery.new(all_hosts, {older: 2.weeks.before(Date.today)}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(vpngw, pc5) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(vpngw.id, pc5.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_falsey }
      it { expect(subject.include?(pc2)).to be_falsey }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_truthy }
      it { expect(subject.include?(vpngw)).to be_truthy }
    end
  end # search :older

  context "with :newer" do
    subject { HostQuery.new(all_hosts, {newer: 1.day.before(Date.today)}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas, pc2, pc3) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id, pc2.id, pc3.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :newer

  context "with :current" do
    subject { HostQuery.new(all_hosts, {current: 1}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(vpngw, nas, pc2, pc3) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(vpngw.id, nas.id, pc2.id, pc3.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_truthy }
      it { expect(subject.include?(pc3)).to be_truthy }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_truthy }
    end
  end # search :current

  context "with :host_category" do
    subject { HostQuery.new(all_hosts, {host_category: 'inu'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(vpngw) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(vpngw.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_falsey }
      it { expect(subject.include?(pc2)).to be_falsey }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_truthy }
    end
  end # search :host_category

  context "with :lid" do
    subject { HostQuery.new(all_hosts, {lid: 'paRis'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas) }
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_falsey }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
    end
  end # search :lid

  context "with :merkmal_responsible" do
    let(:merkmalklasse) { FactoryGirl.create(:merkmalklasse,
      name: 'Responsible',
      format: 'string',
      for_object: 'Host',
      visible: ['index', '']
    )}
    let!(:merkmal) { FactoryGirl.create(:merkmal, 
      merkmalfor: nas,
      merkmalklasse: merkmalklasse,
      value: 'Gandalf'
    )}
    subject { HostQuery.new(all_hosts, {merkmal_responsible: 'gAnDalf'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(nas) }
      # it "debug" do
      #   pp Merkmalklasse.visibles(:host, 'index')
      # end
    end
    describe "#find_each" do
      it "executes matching hosts" do
        hosts = []
        subject.find_each do |host|
          hosts << host.id
        end
        expect(hosts).to contain_exactly(nas.id)
      end
    end
    describe "#include?" do
      it { expect(subject.include?(nas)).to be_truthy }
      it { expect(subject.include?(pc2)).to be_falsey }
      it { expect(subject.include?(pc3)).to be_falsey }
      it { expect(subject.include?(pc5)).to be_falsey }
      it { expect(subject.include?(vpngw)).to be_falsey }
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
end
