require 'rails_helper'

RSpec.describe NetworkInterface, type: :model do
  it { is_expected.to belong_to(:host) }
  it { is_expected.to validate_presence_of(:ip) }
  it { is_expected.to validate_presence_of(:lastseen) }

  it "should get plain factory working" do
    f = FactoryBot.create(:network_interface)
    g = FactoryBot.create(:network_interface)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  describe "on save" do
    let(:host) { FactoryBot.create(:host) }
    describe "mac address" do
      it "normalize 00:11:D2:f3:a4:B5" do
        iface = NetworkInterface.create!(host: host, ip: '192.0.2.35', lastseen: Date.today, mac: '00:11:D2:f3:a4:B5')
        iface.reload
        expect(iface.mac).to eq("0011D2F3A4B5")
      end
      it "normalize 00-11-D2-f3-a4-B5" do
        iface = NetworkInterface.create!(host: host, ip: '192.0.2.35', lastseen: Date.today, mac: '00-11-D2-f3-a4-B5')
        iface.reload
        expect(iface.mac).to eq("0011D2F3A4B5")
      end
      it "normalize doublicate mac to single one" do
        iface = NetworkInterface.create!(host: host, ip: '192.0.2.35', lastseen: Date.today, mac: "5C:26:0A:76:65:E5\nD0:DF:9A:D8:62:71")
        iface.reload
        expect(iface.mac).to eq("5C260A7665E5")
      end
    end
    describe "oui vendor" do
      let!(:macprefix) { MacPrefix.create!(oui: '0011D2', vendor: 'Mustermax Ltd.' ) }
      let!(:macprefix2) { MacPrefix.create!(oui: '5C260A', vendor: 'Musterpartner' ) }
      it "sets oui vendor if blank?" do
        iface = NetworkInterface.create!(host: host, ip: '192.0.2.35', lastseen: Date.today, mac: '00:11:D2:f3:a4:B5')
        iface.reload
        expect(iface.oui_vendor).to eq("Mustermax Ltd.")
      end

      it "sets oui vendor if mac_changed?" do
        iface = NetworkInterface.create!(host: host, ip: '192.0.2.35', lastseen: Date.today, mac: '00:11:D2:f3:a4:B5')
        iface.reload
        iface.update(mac: '5C:26:0A:76:65:E5')
        expect(iface.oui_vendor).to eq("Musterpartner")
      end
    end
  end

  describe "#current" do    
    let!(:if1) { FactoryBot.create(:network_interface, lastseen: Date.today) }
    let!(:if2) { FactoryBot.create(:network_interface, lastseen: 1.month.before(Date.today)) }
    let!(:if3) { FactoryBot.create(:network_interface, lastseen: 5.weeks.before(Date.today)) }

    it { expect(NetworkInterface.current.all).to contain_exactly(if1, if2) }
  end
end
