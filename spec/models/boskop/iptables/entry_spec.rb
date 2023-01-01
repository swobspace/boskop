require 'rails_helper'
  
RSpec.describe Boskop::Iptables::Entry do
let(:logline) { <<EOSTRING
Oct 16 18:39:34 gate kernel: /PF/ AHINT IN=vlan50 OUT=eth1 MAC=fc:aa:14:7d:32:2f:0c:47:c9:c5:3b:1b:08:00 SRC=192.168.50.21 DST=52.94.217.204 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=47964 DF PROTO=TCP SPT=36706 DPT=443 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405140402080A01CE60E90000000001030306) 
EOSTRING
  }

  # check for class methods
  it { expect(Boskop::Iptables::Entry.respond_to? :new).to be_truthy}

  describe "without a logline" do
    subject { Boskop::Iptables::Entry.new() }
    it "::new raise an KeyError" do
      expect { Boskop::Iptables::Entry.new() }.to raise_error(ArgumentError)   
    end
  end

  describe "with invalid logline" do
    subject { Boskop::Iptables::Entry.new(Hash.new) }
    it { expect(subject).not_to be_valid }
  end

  describe "with valid nmaphost and script data" do
    subject { Boskop::Iptables::Entry.new(logline) }

    it { expect(subject.respond_to? :line).to be_truthy}
    it { expect(subject.respond_to? :valid?).to be_truthy}
    it { expect(subject).to be_a_kind_of Boskop::Iptables::Entry }
    it { expect(subject).to be_valid }
    it { expect(subject.timestamp).to eq(Time.parse('Oct 16 18:39:34')) }
    it { expect(subject.host).to eq("gate") }
    it { expect(subject.src).to eq('192.168.50.21') }
    it { expect(subject.dst).to eq('52.94.217.204') }
    it { expect(subject.mac).to eq('fc:aa:14:7d:32:2f:0c:47:c9:c5:3b:1b:08:00') }
    it { expect(subject.src_mac).to eq('0c:47:c9:c5:3b:1b') }
    it { expect(subject.dst_mac).to eq('fc:aa:14:7d:32:2f') }
    it { expect(subject.etherproto).to eq('08:00') }
  end

end
