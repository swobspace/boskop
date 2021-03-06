require 'rails_helper'

module Hosts
  RSpec.describe Creator do
    subject { Creator.new(attributes: attributes) }
    let(:loc) { FactoryBot.create(:location, lid: 'JCST') }
    let!(:n1) { FactoryBot.create(:network, netzwerk: '192.0.2.0/24', location: loc) }
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

    let(:attributes) {{
      "name" => "Mumpitz",
      "lastseen" => "2019-04-15",
      "ip" => "192.0.2.35",
      "mac" => '00:11:22:33:44:55',
      "description" => "some info about the host",
      "if_description" => "about the network interface",
      "cpe" => "cpe:/o:microsoft:windows_10::-",
      "raw_os" => "Windows 10 Pro 15063",
      "fqdn" => "Mumpitz.example.net",
      "workgroup" => "EXANET",
      "domain_dns" => "example.net",
      "vendor" => "Frodo",
      "serial" => "XYZTAG",
      "uuid" => "13d1a35d-e6da-4247-8dbd-13124172779b",
      "product" => "Frodo Beutlinex 1704",
      "warranty_sla" => "3 years bring in",
      "warranty_start" => "2018-08-01",
      "warranty_end" => "2021-07-31",
      "merkmal_responsible" => "KrummhoernigerSchnarchkackler",
      "merkmal_next" => "My next steps"
    }}
    # check for class methods
    it { expect(Creator.respond_to? :new).to be_truthy}

    # check for instance methods
    describe "instance methods" do
      it { expect(subject.respond_to? :save).to be_truthy}
      it { expect(subject.respond_to? :host).to be_truthy}
    end

    describe "without arguments" do
      it "raise an KeyError" do
        expect {
          Creator.new
        }.to raise_error(KeyError)
      end
    end

    describe "with wrong :mode" do
      it "raise an ArgumentError" do
        expect {
          Creator.new(mode: :bla, attributes: {})
        }.to raise_error(ArgumentError)
      end
    end

    describe "without existing host" do
      describe "#host" do
        it { expect(subject.host).to eq(nil) }
      end

      describe "#save" do
        describe "without :lastseen" do
          let(:attributes) {{}}
          it { expect(subject.save).to be_falsey }
        end

        describe "with :lastseen, without :ip" do
          let(:attributes) {{lastseen: Date.today}}
          it { expect(subject.save).to be_truthy }
          it "creates a new host" do
            expect {
              subject.save
            }.to change{Host.count}.by(1)
          end
        end

        describe "with :lastseen, with :ip" do
          let(:attributes) {{lastseen: Date.today, ip: '192.0.2.35'}}
          it { expect(subject.save).to be_truthy }
          it "creates a new host" do
            expect {
              subject.save
            }.to change{Host.count}.by(1)
          end
        end

        context "creates a new host" do
          let(:host) { subject.save; subject.host }
          let(:iface) { host.network_interfaces.first }
          it { expect(subject.save).to be_truthy }
          it { expect(host).to be_kind_of(Host) }
          it { expect(host).to be_valid }
          it { expect(host.name).to eq("Mumpitz") }
          it { expect(host.lastseen.to_s).to eq("2019-04-15") }
          it { expect(host.ip).to eq("192.0.2.35") }
          it { expect(host.mac).to eq('001122334455') }
          it { expect(host.description).to eq("some info about the host") }
          it { expect(iface.ip).to eq("192.0.2.35") }
          it { expect(iface.mac).to eq('001122334455') }
          it { expect(iface.if_description).to eq("about the network interface") }
          it { expect(host.cpe).to eq("/o:microsoft:windows_10::-") }
          it { expect(host.raw_os).to eq("Windows 10 Pro 15063") }
          it { expect(host.fqdn).to eq("Mumpitz.example.net") }
          it { expect(host.workgroup).to eq("EXANET") }
          it { expect(host.domain_dns).to eq("example.net") }
          it { expect(host.vendor).to eq("Frodo") }
          it { expect(host.serial).to eq("XYZTAG") }
          it { expect(host.uuid).to eq("13d1a35d-e6da-4247-8dbd-13124172779b") }
          it { expect(host.product).to eq("Frodo Beutlinex 1704") }
          it { expect(host.warranty_sla).to eq("3 years bring in") }
          it { expect(host.warranty_start.to_s).to eq("2018-08-01") }
          it { expect(host.warranty_end.to_s).to eq("2021-07-31") }
          it { expect(host.merkmal_responsible).to eq("KrummhoernigerSchnarchkackler") }
          it { expect(host.merkmal_next).to eq("My next steps") }
        end
      end

      describe "without a location" do
        let(:host) { subject.save; subject.host }
        it "sets location from ip address and existing networks" do
          expect(host.location).to eq(loc)
        end

        it "doesn't set location if there is no uniq matching network" do
          n2 = FactoryBot.create(:network, netzwerk: '192.0.2.0/24')
          expect(host.location).to be_nil
        end
      end
    end # non existent host

    describe "on existing host" do
      let(:uuface) { FactoryBot.create(:network_interface,
        ip: '192.0.2.7',
        mac: '00:11:22:33:44:55',
        lastseen: '2019-04-01',
      )}
      let!(:uuid_host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        name: 'oldname',
        cpe: 'oldcpe',
        description: 'olddescription',
        raw_os: 'oldrawos',
        uuid: '13d1a35d-e6da-4247-8dbd-13124172779b',
        network_interfaces: [uuface],
        merkmale_attributes: [
          { merkmalklasse_id: mk_next.id, value: "old steps" },
        ]
      )}
      let!(:serial_host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        serial: 'XYZTAG',
      )}
      let!(:blacklisted_uuid_host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        uuid: '00000001-0002-0003-0005-000000000009',
        name: 'Wargh',
      )}
      let!(:other_blacklisted_uuid_host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        uuid: '00000001-0002-0003-0005-000000000009',
        name: 'Judas',
      )}
      let!(:blacklisted_serial_host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        serial: 'O.E.M.',
        name: 'Wargh',
      )}
      let!(:other_blacklisted_serial_host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        serial: 'O.E.M.',
        name: 'Judas',
      )}
      let(:ipface) { FactoryBot.create(:network_interface,
        ip: '192.0.2.9',
        mac: '00:11:22:33:44:AA',
        lastseen: '2019-04-01',
      )}
      let!(:ip_host) { FactoryBot.create(:host,
        name: 'ip_host',
        lastseen: '2019-04-01',
        network_interfaces: [ipface],
      )}

      describe "with blacklisted uuid" do
        let(:attributes) {{
          uuid: '00000001-0002-0003-0005-000000000009',
          name: 'waRGh',
        }}
        before(:each) do
          expect(Boskop).to receive(:uuid_blacklist).and_return(['00000001-0002-0003-0005-000000000009'])
        end
        it { expect(subject.host).to eq(blacklisted_uuid_host) }
      end

      describe "with blacklisted serial" do
        let(:attributes) {{
          serial: 'O.E.M.',
          name: 'juDaS',
        }}
        before(:each) do
          expect(Boskop).to receive(:serial_blacklist).and_return(['O.E.M.'])
        end
        it { expect(subject.host).to eq(other_blacklisted_serial_host) }
      end

      describe "with existing uuid" do
        let(:attributes) {{
          lastseen: '2019-04-15',
          uuid: '13d1a35d-e6da-4247-8dbd-13124172779b',
        }}
        it { expect(subject.host).to eq(uuid_host) }
      end

      describe "with existing serial" do
        let(:attributes) {{
          lastseen: '2019-04-15',
          serial: 'XYZTAG',
        }}
        it { expect(subject.host).to eq(serial_host) }
      end
     
      describe "with existing ip" do
        let(:attributes) {{
          lastseen: '2019-04-15',
          name: 'ip_host',
          ip: '192.0.2.17',
        }}

        it "doesn't create a new host" do
          expect {
            subject.save
          }.to change(Host, :count).by(0)
        end
        it { subject.save; expect(subject.host).to eq(ip_host) }
        it { subject.save; ip_host.reload; expect(ip_host.lastseen.to_s).to eq('2019-04-15') }

        describe "with same mac" do
          let(:attributes) {{
            lastseen: '2019-04-15',
            ip: '192.0.2.9',
            mac: '00:11:22:33:44:AA',
          }}
          let(:host) { subject.save; subject.host }
          it { expect(subject.host).to eq(ip_host) }
          it { expect(host.mac).to eq('0011223344AA') }
          it { expect(ip_host.network_interfaces.count).to eq(1) }
        end

        describe "with changed mac" do
          let(:attributes) {{
            lastseen: '2019-04-15',
            ip: '192.0.2.9',
            mac: 'AA-BB-CC-DD-EE-FF',
          }}
          let(:host) { subject.save; subject.host }
          it { expect(subject.host).to eq(ip_host) }
          it { expect(host.mac).to eq('AABBCCDDEEFF') }
          it { expect(host.network_interfaces.count).to eq(2) }
        end

        describe "with blank mac" do
          let(:attributes) {{
            lastseen: '2019-04-15',
            ip: '192.0.2.7',
            mac: '',
          }}
          let(:host) { subject.save; subject.host }
          it { expect(host.mac).to eq('001122334455') }
        end

        describe "without a location" do
          let(:host) { subject.save; subject.host }
          it "sets location from ip address and existing networks" do
            expect(host.location).to eq(loc)
          end

          it "doesn't set location if there is no uniq matching network" do
            n2 = FactoryBot.create(:network, netzwerk: '192.0.2.0/24')
            expect(host.location).to be_nil
          end
        end
      end

      describe "mode :newer and newer attributes" do
        before(:each) do 
          # uuid_host.network_interfaces << ipface
          Creator.new(mode: :newer, attributes: attributes).save
          uuid_host.reload
        end

        it { expect(uuid_host.lastseen.to_s).to eq("2019-04-15") }
        it { expect(uuid_host.name).to eq("Mumpitz") }
        it { expect(uuid_host.ip).to eq("192.0.2.35") }
        it { expect(uuid_host.mac).to eq('001122334455') }
        it { expect(uuid_host.description).to eq("some info about the host") }
        it { expect(uuid_host.cpe).to eq("/o:microsoft:windows_10::-") }
        it { expect(uuid_host.raw_os).to eq("Windows 10 Pro 15063") }
        it { expect(uuid_host.fqdn).to eq("Mumpitz.example.net") }
        it { expect(uuid_host.workgroup).to eq("EXANET") }
        it { expect(uuid_host.domain_dns).to eq("example.net") }
        it { expect(uuid_host.vendor).to eq("Frodo") }
        it { expect(uuid_host.serial).to eq("XYZTAG") }
        it { expect(uuid_host.uuid).to eq("13d1a35d-e6da-4247-8dbd-13124172779b") }
        it { expect(uuid_host.product).to eq("Frodo Beutlinex 1704") }
        it { expect(uuid_host.warranty_sla).to eq("3 years bring in") }
        it { expect(uuid_host.warranty_start.to_s).to eq("2018-08-01") }
        it { expect(uuid_host.warranty_end.to_s).to eq("2021-07-31") }
        it { expect(uuid_host.network_interfaces.count).to eq(2) }
        it { expect(uuid_host.merkmal_next).to eq("My next steps") }
      end

      describe "mode :newer and older attributes" do
        let(:attributes) {{
          lastseen: '2018-12-04', 
          ip: '192.0.2.9',
          mac: 'AA-BB-CC-DD-EE-FF',
          name: 'Blafasel',
        }}
        it "doesn't update host" do
          expect_any_instance_of(Host).to receive(:update).with({})
          hc = Creator.new(mode: :newer, attributes: attributes)
          expect(hc.host).to eq(ip_host)
          hc.save
          host = hc.host
          expect(host.name).to eq("ip_host")
          expect(host.mac).to eq("0011223344AA")
          expect(host.merkmal_next).to eq(nil)
        end
      end

      describe "mode :missing" do
        before(:each) do 
          uuid_host.network_interfaces << ipface
          Creator.new(mode: :missing, attributes: attributes).save
          uuid_host.reload
        end
        it { expect(uuid_host.lastseen.to_s).to eq("2019-04-15") }
        it { expect(uuid_host.name).to eq("oldname") }
        it { expect(uuid_host.ip).to eq("192.0.2.35") }
        it { expect(uuid_host.mac).to eq('001122334455') }
        it { expect(uuid_host.description).to eq("olddescription") }
        it { expect(uuid_host.cpe).to eq("oldcpe") }
        it { expect(uuid_host.raw_os).to eq("oldrawos") }
        it { expect(uuid_host.fqdn).to eq("Mumpitz.example.net") }
        it { expect(uuid_host.workgroup).to eq("EXANET") }
        it { expect(uuid_host.domain_dns).to eq("example.net") }
        it { expect(uuid_host.vendor).to eq("Frodo") }
        it { expect(uuid_host.serial).to eq("XYZTAG") }
        it { expect(uuid_host.uuid).to eq("13d1a35d-e6da-4247-8dbd-13124172779b") }
        it { expect(uuid_host.product).to eq("Frodo Beutlinex 1704") }
        it { expect(uuid_host.warranty_sla).to eq("3 years bring in") }
        it { expect(uuid_host.warranty_start.to_s).to eq("2018-08-01") }
        it { expect(uuid_host.warranty_end.to_s).to eq("2021-07-31") }
        it { expect(uuid_host.merkmal_next).to eq("old steps") }
      end

      describe "mode :always" do
        before(:each) do 
          uuid_host.network_interfaces << ipface
          Creator.new(mode: "always", attributes: attributes).save
          uuid_host.reload
        end
        it { expect(uuid_host.name).to eq("Mumpitz") }
        it { expect(uuid_host.lastseen.to_s).to eq("2019-04-15") }
        it { expect(uuid_host.ip).to eq("192.0.2.35") }
        it { expect(uuid_host.mac).to eq('001122334455') }
        it { expect(uuid_host.description).to eq("some info about the host") }
        it { expect(uuid_host.cpe).to eq("/o:microsoft:windows_10::-") }
        it { expect(uuid_host.raw_os).to eq("Windows 10 Pro 15063") }
        it { expect(uuid_host.fqdn).to eq("Mumpitz.example.net") }
        it { expect(uuid_host.workgroup).to eq("EXANET") }
        it { expect(uuid_host.domain_dns).to eq("example.net") }
        it { expect(uuid_host.vendor).to eq("Frodo") }
        it { expect(uuid_host.serial).to eq("XYZTAG") }
        it { expect(uuid_host.uuid).to eq("13d1a35d-e6da-4247-8dbd-13124172779b") }
        it { expect(uuid_host.product).to eq("Frodo Beutlinex 1704") }
        it { expect(uuid_host.warranty_sla).to eq("3 years bring in") }
        it { expect(uuid_host.warranty_start.to_s).to eq("2018-08-01") }
        it { expect(uuid_host.warranty_end.to_s).to eq("2021-07-31") }
        it { expect(uuid_host.merkmal_next).to eq("My next steps") }
      end

      describe "mode :none" do
        subject { Creator.new(mode: :none, attributes: attributes) }

        it "updates timestamp on existing host" do
          subject.save
          uuid_host.reload
          expect(uuid_host.lastseen.to_s).to eq("2019-04-15")
          expect(uuid_host.merkmal_next).to eq("old steps")
        end

        context "fresher host" do
          let(:attributes) {{ lastseen: "2018-06-07" }}
          it "doesn't update timestamp on existing fresher host" do
            subject.save
            uuid_host.reload
            expect(uuid_host.lastseen.to_s).to eq("2019-04-01")
          end
        end
      end
    end

    # Scenario: hosts exists, has uuid (or serial) attribute set.
    # update the same host from data like Get-ADComputer (powershell),
    # having name and ip, but not other identifier set.
    describe "existing uuid host, but incomplete new data" do
      subject { Creator.new(mode: :newer, attributes: attributes) }
      let(:iface) { FactoryBot.create(:network_interface,
        ip: '192.0.2.7',
        mac: '00:11:22:33:44:55',
        lastseen: '2019-04-01',
      )}
      let!(:host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        name: 'UUname',
        fqdn: 'UUname.example.org',
        uuid: '64e1c15e-764b-11ea-a495-f48e387521dd',
        network_interfaces: [iface],
        description: "oldDescription",
      )}
      describe "matching on name" do
        let(:attributes) {{
          name: 'uuname',
          lastseen: '2019-04-15',
          ip: '192.0.2.9',
          description: "newDescription",
        }}
        it "doesn't create a new Host" do
          expect {
            subject.save
          }.to change{Host.count}.by(0)
        end
        describe "#save" do
          before(:each) do
            subject.save
            host.reload
          end
          it { expect(host.lastseen.to_s).to eq('2019-04-15') }
          it { expect(host.description).to eq('newDescription') }
        end
      end

      describe "matching on fqdn" do
        let(:attributes) {{
          fqdn: 'uuname.example.org',
          lastseen: '2019-04-15',
          ip: '192.0.2.9',
          description: "newDescription",
        }}
        it "doesn't create a new Host" do
          expect {
            subject.save
          }.to change{Host.count}.by(0)
        end
        describe "#save" do
          before(:each) do
            subject.save
            host.reload
          end
          it { expect(host.lastseen.to_s).to eq('2019-04-15') }
          it { expect(host.description).to eq('newDescription') }
        end
      end
    end

    # Scenario: hosts exists, has only name and ip set.
    # Update the same host with full data including uuid attribute
    # should update existing host with same name, but not create a new one.
    describe "existing plain host, new data containing uuid" do
      subject { Creator.new(mode: :newer, attributes: attributes) }
      let(:iface) { FactoryBot.create(:network_interface,
        ip: '192.0.2.7',
        mac: '00:11:22:33:44:55',
        lastseen: '2019-04-01',
      )}
      let!(:host) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        name: 'PlainName',
        fqdn: 'PlainName.example.com',
        description: "oldDescription",
        network_interfaces: [iface],
      )}
      describe "with matching name" do
        let(:attributes) {{
          name: 'plainname',
          uuid: '64e1c15e-764b-11ea-a495-f48e387521dd',
          lastseen: '2019-04-15',
          description: "newDescription",
          ip: '192.0.2.9',
        }}
        it "doesn't create a new Host" do
          expect {
            subject.save
          }.to change{Host.count}.by(0)
        end
        describe "#save" do
          before(:each) do
            subject.save
            host.reload
          end
          it { expect(host.lastseen.to_s).to eq('2019-04-15') }
          it { expect(host.uuid).to eq('64e1c15e-764b-11ea-a495-f48e387521dd') }
          it { expect(host.description).to eq('newDescription') }
        end
      end
      describe "with matching fqdn" do
        let(:attributes) {{
          fqdn: 'plainname.example.com',
          uuid: '64e1c15e-764b-11ea-a495-f48e387521dd',
          lastseen: '2019-04-15',
          description: "newDescription",
          ip: '192.0.2.9',
        }}
        it "doesn't create a new Host" do
          expect {
            subject.save
          }.to change{Host.count}.by(0)
        end
        describe "#save" do
          before(:each) do
            subject.save
            host.reload
          end
          it { expect(host.lastseen.to_s).to eq('2019-04-15') }
          it { expect(host.uuid).to eq('64e1c15e-764b-11ea-a495-f48e387521dd') }
          it { expect(host.description).to eq('newDescription') }
        end
      end
    end

    # Scenario: multiple hosts with same name exists
    # Update only the latest entry
    describe "with multiple hosts with same name" do
      subject { Creator.new(attributes: attributes) }
      let!(:host1) { FactoryBot.create(:host,
        lastseen: '2019-04-01',
        name: 'somehost',
        description: "older version",
      )}
      let!(:host2) { FactoryBot.create(:host,
        lastseen: '2019-04-10',
        name: 'somehost',
        description: "newer version",
      )}
      let(:attributes) {{
        name: 'somehost',
        lastseen: '2019-04-20',
        description: "current version",
      }}
      it "doesn't create a new Host" do
        expect {
          subject.save
        }.to change{Host.count}.by(0)
      end
      describe "#save" do
        before(:each) do
          subject.save
          host1.reload; host2.reload
        end
        it { expect(host1.lastseen.to_s).to eq('2019-04-01') }
        it { expect(host1.description).to eq('older version') }
        it { expect(host2.lastseen.to_s).to eq('2019-04-20') }
        it { expect(host2.description).to eq('current version') }
      end
    end
  end
end
