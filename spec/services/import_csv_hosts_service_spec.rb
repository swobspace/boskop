require 'rails_helper'

RSpec.describe ImportCsvHostsService do
    let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'wob42.csv') }

  # check for class methods
  it { expect(ImportCsvHostsService.respond_to? :new).to be_truthy}

  # check for instance methods
  describe "instance methods" do
    subject { ImportCsvHostsService.new(file: "") }
    it { puts csvfile }
    it { expect(subject.respond_to? :call).to be_truthy}
    it { expect(subject.call.respond_to? :success?).to be_truthy }
    it { expect(subject.call.respond_to? :error_message).to be_truthy }
    it { expect(subject.call.respond_to? :hosts).to be_truthy }
  end

  describe "#call" do
    subject { ImportCsvHostsService.new(file: csvfile) }

    it "calls Host.create" do
      host = instance_double(Host)
      expect(Host).to receive_message_chain(:create_with, :find_or_create_by).with(any_args).and_return(host)
      expect(host).to receive(:persisted?).and_return(false)
      allow(host).to receive_message_chain(:errors, :any?).and_return(true)
      allow(host).to receive_message_chain(:errors, :full_messages).and_return(["a", "b"])
      subject.call
    end

    context "with valid import_attributes" do
      it "creates an Host" do
	expect {
	  subject.call
	}.to change{Host.count}.by(1)
      end

      describe "#call" do
        let(:result) { subject.call }
        it { expect(result.success?).to be_truthy }
        it { expect(result.error_message.present?).to be_falsey }
        it { expect(result.hosts).to be_a_kind_of Array }

        describe "the first host" do
          let(:host) { result.hosts.first }
          it { expect(host).to be_a_kind_of Host }
          it { expect(host).to be_persisted }
          it { expect(host.ip.to_s).to eq("192.168.1.42") }
          it { expect(host.lastseen.to_s).to match(/\A2017-08-20/) }
          it { expect(host.name).to eq("wob42") }
          it { expect(host.mac).to eq("C8:FF:28:78:29:DB") }
          it { expect(host.cpe).to eq("/o:microsoft:windows_10::-") }
          it { expect(host.raw_os).to eq("Windows 10 Pro 15063") }
          it { expect(host.fqdn).to eq("wob42.my.example.net") }
          it { expect(host.workgroup).to eq("MY") }
          it { expect(host.domain_dns).to eq("my.example.net") }
        end
      end
    end

    context "with invalid import_attributes" do
      subject { ImportCsvHostsService.new(file: "") }

      it "creates an Host" do
	expect {
	  subject.call
	}.to change{Host.count}.by(0)
      end

      describe "#call" do
        let(:result) { subject.call }
        it { expect(result.success?).to be_falsey }
        it { expect(result.error_message.present?).to be_truthy }
        it { expect(result.hosts.first).to be_nil }
      end
    end
  end
  
  describe "with existing host" do
    let!(:host) { FactoryGirl.create(:host, 
      ip: '192.168.1.42',
      lastseen: '2017-08-30',
      name: 'myhost',
      cpe: "/o:microsoft:windows:4711",
      fqdn: 'myhost.example.net'
    )}

    describe "update: :none" do
      let(:service) { ImportCsvHostsService.new(file: csvfile, update: :none) }
      it "updates only lastseen" do
        service.call
        host = Host.first
        expect(host.ip.to_s).to eq("192.168.1.42")
        expect(host.lastseen.to_s).to eq("2017-08-30")
        expect(host.name).to eq("myhost")
        expect(host.cpe).to eq("/o:microsoft:windows:4711")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("")
        expect(host.workgroup).to eq("")
      end
    end

    describe "update: :newer" do
      let(:service) { ImportCsvHostsService.new(file: csvfile, update: :newer) }

      it "doesn't update any attribute from old data" do
        service.call
        host = Host.first
        expect(host.ip.to_s).to eq("192.168.1.42")
        expect(host.lastseen.to_s).to eq("2017-08-30")
        expect(host.name).to eq("myhost")
        expect(host.cpe).to eq("/o:microsoft:windows:4711")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("")
        expect(host.workgroup).to eq("")
      end

      it "updates any attribute from current data" do
        host.update_attributes!(lastseen: '2017-07-31')
        service.call
        host = Host.first
        expect(host.lastseen.to_s).to eq("2017-08-20")
        expect(host.ip.to_s).to eq("192.168.1.42")
        expect(host.name).to eq("wob42")
        expect(host.cpe).to eq("/o:microsoft:windows_10::-")
        expect(host.fqdn).to eq("wob42.my.example.net")
        expect(host.domain_dns).to eq("my.example.net")
        expect(host.workgroup).to eq("MY")
      end
    end
    describe "update: :missing" do
      let!(:service) { ImportCsvHostsService.new(file: csvfile, update: :missing) }

      it "updates only missing attributes if data is not older than 4 weeks" do
        service.call
        host = Host.first
        expect(host.ip.to_s).to eq("192.168.1.42")
        expect(host.lastseen.to_s).to eq("2017-08-30")
        expect(host.name).to eq("myhost")
        expect(host.cpe).to eq("/o:microsoft:windows:4711")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("my.example.net")
        expect(host.workgroup).to eq("MY")
      end
      it "doesn't update any attribute from old data" do
        host.update(lastseen: '2017-09-30')
        service.call
        host = Host.first
        expect(host.ip.to_s).to eq("192.168.1.42")
        expect(host.lastseen.to_s).to eq("2017-09-30")
        expect(host.name).to eq("myhost")
        expect(host.cpe).to eq("/o:microsoft:windows:4711")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("")
        expect(host.workgroup).to eq("")
      end

    end
  end
end
