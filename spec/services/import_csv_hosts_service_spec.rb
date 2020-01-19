require 'rails_helper'

RSpec.describe ImportCsvHostsService do
  let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'wob42.csv') }
  let!(:mk_responsible) { FactoryBot.create(:merkmalklasse,
    name: "Responsible",
    tag: "responsible",
    for_object: "Host",
  )}
  let!(:mk_next) { FactoryBot.create(:merkmalklasse,
    name: "NextSteps",
    tag: "next",
    for_object: "Host",
  )}

  # check for class methods
  it { expect(ImportCsvHostsService.respond_to? :new).to be_truthy}

  # check for instance methods
  describe "instance methods" do
    subject { ImportCsvHostsService.new(file: "") }
    it { expect(subject.respond_to? :call).to be_truthy}
    it { expect(subject.call.respond_to? :success?).to be_truthy }
    it { expect(subject.call.respond_to? :error_message).to be_truthy }
    it { expect(subject.call.respond_to? :hosts).to be_truthy }
  end

  describe "#call" do
    subject { ImportCsvHostsService.new(file: csvfile, update: :always) }

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
          it { expect(host.serial).to eq("XXX7785G") }
          it { expect(host.cpe).to eq("/o:microsoft:windows_10::-") }
          it { expect(host.raw_os).to eq("Windows 10 Pro 15063") }
          it { expect(host.fqdn).to eq("wob42.my.example.net") }
          it { expect(host.workgroup).to eq("MY") }
          it { expect(host.domain_dns).to eq("my.example.net") }
          it { expect(host.vendor).to eq("VeryBigComputerCorp.") }
          it { expect(host.merkmal_responsible).to eq("KrummhoernigerSchnarchkackler") }
          it { expect(host.merkmal_next).to eq("My next steps") }
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
    let!(:host) { FactoryBot.create(:host,
      lastseen: '2017-08-30',
      name: 'myhost',
      cpe: "/o:microsoft:windows:4711",
      fqdn: 'myhost.example.net',
      serial: 'XXX7785G',
      merkmale_attributes: [
        { merkmalklasse_id: mk_next.id, value: "old steps" },
      ]
    )}
    let!(:if_host) { FactoryBot.create(:network_interface,
      host: host,
      ip: '192.168.1.42',
      lastseen: '2017-08-30',
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
        expect(host.merkmal_responsible).to eq(nil)
        expect(host.merkmal_next).to eq("old steps")
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
        expect(host.merkmal_responsible).to eq(nil)
        expect(host.merkmal_next).to eq("old steps")
      end

      it "updates any attribute from current data" do
        host.update!(lastseen: '2017-07-31')
        service.call
        host = Host.first
        expect(host.lastseen.to_s).to eq("2017-08-20")
        expect(host.ip.to_s).to eq("192.168.1.42")
        expect(host.name).to eq("wob42")
        expect(host.cpe).to eq("/o:microsoft:windows_10::-")
        expect(host.fqdn).to eq("wob42.my.example.net")
        expect(host.domain_dns).to eq("my.example.net")
        expect(host.workgroup).to eq("MY")
        expect(host.merkmal_responsible).to eq("KrummhoernigerSchnarchkackler")
        expect(host.merkmal_next).to eq("My next steps")
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
        expect(host.cpe).to eq("")
        expect(host.raw_os).to eq("Windows 10 Pro 15063")
        expect(host.fqdn).to eq("myhost.example.net")
        expect(host.domain_dns).to eq("my.example.net")
        expect(host.workgroup).to eq("MY")
        expect(host.merkmal_responsible).to eq("KrummhoernigerSchnarchkackler")
        expect(host.merkmal_next).to eq("old steps")
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
        expect(host.merkmal_responsible).to eq("KrummhoernigerSchnarchkackler")
        expect(host.merkmal_next).to eq("old steps")
      end

    end
  end

  describe "importing relations from *_id fields" do
    let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'relations.csv') }
    let!(:operating_system) { FactoryBot.create(:operating_system,
      id: 771,
      name: "Linux",
    )}
    let!(:host_category)    { FactoryBot.create(:host_category,
      id: 772,
      name: "Linux/Webserver",
      tag: "lin_web"
    )}
    let!(:location)         { FactoryBot.create(:location,
      id: 773,
      name: "@home",
      lid: "HOME",
    )}
    let(:result) { ImportCsvHostsService.new(file: csvfile).call }
    let(:hosts)  { result.hosts }

    it { expect(hosts[0].ip.to_s).to eq("192.168.1.42") }
    it { expect(hosts[0].operating_system_id).to eq(operating_system.id) }
    it { expect(hosts[0].host_category_id).to eq(host_category.id) }
    it { expect(hosts[0].location_id).to eq(location.id) }
    it { expect(hosts[1].ip.to_s).to eq("192.168.1.43") }
    it { expect(hosts[1].operating_system_id).to eq(operating_system.id) }
    it { expect(hosts[1].host_category_id).to eq(host_category.id) }
    it { expect(hosts[1].location_id).to eq(location.id) }
    it { expect(hosts[2].ip.to_s).to eq("192.168.1.44") }
    it { expect(hosts[2].operating_system_id).to eq(operating_system.id) }
    it { expect(hosts[2].host_category_id).to eq(host_category.id) }
    it { expect(hosts[2].location_id).to eq(location.id) }
  end
end
