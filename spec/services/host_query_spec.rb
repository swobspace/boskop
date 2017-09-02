require 'rails_helper'

RSpec.describe HostQuery do
  include_context "host variables"
  let(:all_hosts) { Host.left_outer_joins(:location, :host_category) }


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
      it { puts subject.all.to_sql }
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

  context "with :host_category" do
    subject { HostQuery.new(all_hosts, {host_category: 'Linux'}) }
    describe "#all" do
      it { expect(subject.all).to contain_exactly(vpngw) }
      it { puts subject.all.to_sql }
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
      it { puts subject.all.to_sql }
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
end
