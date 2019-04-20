require 'rails_helper'

RSpec.describe ImportNmapXmlService do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'smb-os-discovery-42.xml') }

  # check for class methods
  it { expect(ImportNmapXmlService.respond_to? :new).to be_truthy}

  # check for instance methods
  describe "instance methods" do
    subject { ImportNmapXmlService.new(file: "") }
    it { expect(subject.respond_to? :call).to be_truthy}
    it { expect(subject.call.respond_to? :success?).to be_truthy }
    it { expect(subject.call.respond_to? :error_message).to be_truthy }
    it { expect(subject.call.respond_to? :hosts).to be_truthy }
  end

  describe "#call" do
    subject { ImportNmapXmlService.new(file: nmapxml) }

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
          it { expect(host.mac).to eq("C8FF287829DB") }
          it { expect(host.cpe).to eq("/o:microsoft:windows_10::-") }
          it { expect(host.raw_os).to eq("Windows 10 Pro 15063") }
          it { expect(host.fqdn).to eq("DESKTOP-6GLIL73") }
          it { expect(host.workgroup).to eq("WORKGROUP") }
          it { expect(host.domain_dns).to eq("DESKTOP-6GLIL73") }
        end
      end
    end

    context "with invalid import_attributes" do
      subject { ImportNmapXmlService.new(file: "") }

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
    let(:ehost) { FactoryBot.create(:host, 
      lastseen: 1.day.ago(Date.today),
      name: 'myhost',
      cpe: "/o:microsoft:windows:4711",
      fqdn: 'myhost.example.net'
    )}
    let!(:if_ehost) { FactoryBot.create(:network_interface,
      host: ehost,
      ip: '192.51.100.17',
      lastseen: 1.day.ago(Date.today),
    )}
    let(:attributes) {{
      ip: '192.51.100.17',
      name: 'otherhost',
      cpe: "/o:linux:tux",
      fqdn: 'otherhost.example.net',
      domain_dns: 'example.net',
      workgroup: 'WORKGROUP5',
    }}
    before(:each) do
      allow_any_instance_of(Boskop::NMAP::Host).to receive(:attributes).and_return(attributes)
    end

    describe "update: :none" do
      let(:service) { ImportNmapXmlService.new(file: nmapxml, update: :none) }
      before(:each) do
        attributes.merge!(lastseen: 1.week.after(Date.today).to_s)
      end
      it "updates only lastseen" do
        service.call
        ehost.reload
        expect(ehost.ip.to_s).to eq("192.51.100.17")
        expect(ehost.lastseen.to_s).to eq(1.week.after(Date.today).to_s)
        expect(ehost.name).to eq("myhost")
        expect(ehost.cpe).to eq("/o:microsoft:windows:4711")
        expect(ehost.fqdn).to eq("myhost.example.net")
        expect(ehost.domain_dns).to eq("")
        expect(ehost.workgroup).to eq("")
      end
    end

    describe "update: :newer" do
      let(:service) { ImportNmapXmlService.new(file: nmapxml, update: :newer) }

      it "doesn't update any attribute from old data" do
        attributes.merge!(lastseen: 1.year.ago(Date.today).to_s)
        service.call
        host = Host.first
        expect(host.ip.to_s).to eq("192.51.100.17")
        expect(host.lastseen.to_s).to eq(1.day.ago(Date.today).to_s)
        expect(host.name).to eq("myhost")
        expect(host.cpe).to eq("/o:microsoft:windows:4711")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("")
        expect(host.workgroup).to eq("")
      end

      it "updates any attribute from current data" do
        attributes.merge!(lastseen: 1.week.after(Date.today))
        service.call
        host = Host.first
        expect(host.lastseen.to_s).to eq(1.week.after(Date.today).to_s)
        expect(host.ip.to_s).to eq("192.51.100.17")
        expect(host.name).to eq("otherhost")
        expect(host.cpe).to eq("/o:linux:tux")
        expect(host.fqdn).to eq("otherhost.example.net")
        expect(host.domain_dns).to eq("example.net")
        expect(host.workgroup).to eq("WORKGROUP5")
      end
    end
    describe "update: :missing" do
      let!(:service) { ImportNmapXmlService.new(file: nmapxml, update: :missing) }

      it "updates only missing attributes if data is not older than 4 weeks" do
        attributes.merge!(lastseen: 2.weeks.before(Date.today))
        service.call
        host = Host.first
        expect(host.ip.to_s).to eq("192.51.100.17")
        expect(host.lastseen.to_s).to eq(1.day.before(Date.today).to_s)
        expect(host.name).to eq("myhost")
        expect(host.cpe).to eq("/o:microsoft:windows:4711")
        expect(host.raw_os).to eq("")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("example.net")
        expect(host.workgroup).to eq("WORKGROUP5")
      end

      it "doesn't update any attribute from old data" do
        attributes.merge!(lastseen: 1.year.ago(Date.today).to_s)
        service.call
        host = Host.first
        expect(host.ip.to_s).to eq("192.51.100.17")
        expect(host.lastseen.to_s).to eq(1.day.ago(Date.today).to_s)
        expect(host.name).to eq("myhost")
        expect(host.cpe).to eq("/o:microsoft:windows:4711")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("")
        expect(host.workgroup).to eq("")
      end

    end
  end
end
