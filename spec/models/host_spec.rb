require 'rails_helper'

RSpec.describe Host, type: :model do
  it { is_expected.to belong_to(:host_category).optional }
  it { is_expected.to belong_to(:location).optional }
  it { is_expected.to belong_to(:operating_system).optional }
  it { is_expected.to have_many(:merkmale) }
  it { is_expected.to have_many(:vulnerabilities) }
  it { is_expected.to have_many(:network_interfaces) }
  it { is_expected.to validate_presence_of(:lastseen) }

  it { is_expected.to accept_nested_attributes_for(:network_interfaces) }

  it "should get plain factory working" do
    f = FactoryBot.create(:host)
    g = FactoryBot.create(:host)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  describe "#to_s" do
    let(:h) { FactoryBot.create(:host, name: 'anyhost') }
    describe "without interface" do
      it { expect("#{h}").to match (" (anyhost)") }
    end
    describe "with given interface" do
      let!(:if) { FactoryBot.create(:network_interface, ip: '192.0.2.77', host: h) }
      it { expect("#{h}").to match ("192.0.2.77 (anyhost)") }
    end
  end

  describe "#ip" do
    let(:h) { FactoryBot.create(:host, name: 'anyhost') }
    describe "without interface" do
      it { expect(h.ip).to eq(nil) }
    end
    describe "with given interface" do
      let!(:if) { FactoryBot.create(:network_interface, ip: '192.0.2.77', host: h) }
      it { expect(h.ip).to eq("192.0.2.77") }
      
    end
  end

  describe "Merkmale" do
    let(:host) { FactoryBot.create(:host) }
    describe "#merkmal_doesnotexist" do
      it { expect { host.merkmal_doesnotexist }.to raise_error(NoMethodError) }
      it { expect { host.merkmal_doesnotexist=5 }.to raise_error(NoMethodError) }
    end

    describe "#merkmal_responsible" do
      let!(:merkmalklasse) { FactoryBot.create(:merkmalklasse,
        name: "Responsible",
        tag: 'responsible',
        for_object: 'Host'
      )}
      it { expect(host.merkmal_responsible.nil?).to be_truthy }
      it { expect(host.merkmal_responsible="Mr.X").to eq("Mr.X") }
      it "assigns merkmal with value" do
        host.merkmal_responsible = "Mr.X"
        host.reload
        expect(host.merkmale.where(merkmalklasse_id: merkmalklasse.id).
               first.value).to eq("Mr.X")
      end

      it "creates merkmal on first call and overwrites existing on second call" do
        host.merkmal_responsible = "first person"
        expect(host.merkmal_responsible).to eq("first person")
        host.merkmal_responsible = "second person"
        expect(host.merkmal_responsible).to eq("second person")
        expect(host.merkmale.where(merkmalklasse_id: merkmalklasse.id).count).to eq(1)
      end

      context "with preassigned merkmal value" do
        let!(:merkmal) {FactoryBot.create(:merkmal,
          merkmalklasse_id: merkmalklasse.id,
          merkmalfor: host,
          value: "Hercule Poirot"
        )}
        it { expect(host.merkmal_responsible).to eq("Hercule Poirot") }
      end
    end
  end

  describe "on save" do
    describe "without a location" do
      let(:loc) { FactoryBot.create(:location, lid: 'JCST') }
      let!(:n1) { FactoryBot.create(:network, netzwerk: '192.0.2.0/24', location: loc) }

      it "sets location from ip address and existing networks" do
        iface = FactoryBot.create(:network_interface, ip: '192.0.2.35')
        host = Host.create!(interfaces: [iface], lastseen: Date.today)
        host.reload
        expect(host.location).to eq(loc)
      end

      it "doesn't set location if there is no uniq matching network" do
        n2 = FactoryBot.create(:network, netzwerk: '192.0.2.0/24')
        iface = FactoryBot.create(:network_interface, ip: '192.0.2.35')
        host = Host.create!(network_interfaces: [iface], lastseen: Date.today)
        host.reload
        expect(host.location).to be_nil
      end
    end

  end

  describe "changing :cpe or :raw_os" do
    let(:os) { FactoryBot.create(:operating_system, name: "DummyOS") }
    describe "updating :raw_os" do
      let!(:host) { FactoryBot.create(:host, ip: '192.0.2.35',
                      cpe: 'o/brabbel', operating_system: os) }
      it "clears cpe and os" do
        host.update(raw_os: 'TrueOS')
        host.reload
        expect(host.cpe).to eq("")
        expect(host.operating_system_id).to be_nil
      end
    end
    describe "updating :cpe" do
      let!(:host) { FactoryBot.create(:host, ip: '192.0.2.35',
                      raw_os: 'DummyOS', operating_system: os) }
      it "clears raw_os and os" do
        host.update(cpe: 'o/keiner')
        host.reload
        expect(host.raw_os).to eq("")
        expect(host.operating_system_id).to be_nil
      end
    end
  end

  describe "assign_operating_system" do
    let(:os) { FactoryBot.create(:operating_system, name: "DummyOS") }
    let!(:osm1) { FactoryBot.create(:operating_system_mapping,
      field: :cpe,
      value: '/o:dummy_os',
      operating_system: os
    )}
    let!(:osm2) { FactoryBot.create(:operating_system_mapping,
      field: :raw_os,
      value: 'DummyOS',
      operating_system: os
    )}

    describe "with cpe: o:dummy_os" do
      let(:host) { FactoryBot.create(:host, ip: '192.0.2.35', cpe: '/o:dummy_os') }
      it "assigns an operating system" do
        host.assign_operating_system
        host.reload
        expect(host.operating_system).to eq(os)
      end
    end

    describe "with raw_os: DummyOS" do
      let(:host) { FactoryBot.create(:host, ip: '192.0.2.35', raw_os: 'DummyOS') }
      it "assigns an operating system" do
        host.assign_operating_system
        host.reload
        expect(host.operating_system).to eq(os)
      end
    end
  end

  describe "#most_critical_vulnerability" do
    let(:host) { FactoryBot.create(:host)}
    let(:h) { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.3)}
    let(:m) { FactoryBot.create(:vulnerability_detail, threat: 'Medium', severity: 5.0)}
    let(:l) { FactoryBot.create(:vulnerability_detail, threat: 'Low', severity: 2.1)}
    let(:c) { FactoryBot.create(:vulnerability_detail, threat: 'Critical', severity: 10.0)}

    let!(:vh) { FactoryBot.create(:vulnerability, host: host, vulnerability_detail: h)}
    let!(:vm) { FactoryBot.create(:vulnerability, host: host, vulnerability_detail: m)}
    let!(:vc) { FactoryBot.create(:vulnerability, host: host, vulnerability_detail: c)}
    let!(:vl) { FactoryBot.create(:vulnerability, host: host, vulnerability_detail: l)}

    it { expect(host.most_critical_vulnerability).to eq(vc) }

  end

  describe "::merkmalklassen" do
    let!(:mk1) { FactoryBot.create(:merkmalklasse, for_object: 'Host') }
    let!(:mk2) { FactoryBot.create(:merkmalklasse, for_object: 'Host') }
    let!(:mk3) { FactoryBot.create(:merkmalklasse, for_object: 'Location') }

    it { expect(Host.merkmalklassen).to contain_exactly(mk1, mk2) }
  end
end
