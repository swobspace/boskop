require 'rails_helper'

RSpec.describe Network, :type => :model do
  let(:location) { FactoryGirl.create(:location, lid: 'JCST') }
  it { is_expected.to belong_to(:location) }
  it { is_expected.to have_many(:merkmale) }

  it { is_expected.to validate_presence_of(:location_id) }
  it { is_expected.to validate_presence_of(:netzwerk) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:network)
    g = FactoryGirl.create(:network)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:network, netzwerk: "192.0.2.128/25")
    expect("#{f}").to match /192.0.2.128\/25/
  end

  describe "#to_str" do
    let(:netzwerk) { FactoryGirl.create(:network,
                     location_id: 1, netzwerk: '192.0.2.0/24') }
    it { expect(netzwerk.to_str).to eq("192.0.2.0/24") }
  end

  it "allows update on netzwerk" do
    n1 = FactoryGirl.create(:network, netzwerk: "192.0.2.0/25", location: location)
    n2 = FactoryGirl.create(:network, netzwerk: "192.0.2.128/25", location: location)
    n3 = FactoryGirl.create(:network, netzwerk: "192.0.0.0/21", location: location)
    expect(n2.to_str).to eq("192.0.2.128/25")
    n2.update(netzwerk: "192.0.2.0/24")
    n2.reload
    expect(n2.to_str).to eq("192.0.2.0/24")
  end

  it "does not create networks with same location_id and netzwerk" do
    f = FactoryGirl.create(:network, location_id: 1, netzwerk: '192.0.2.0/24')
    expect(f).to be_valid
    expect{ 
      FactoryGirl.create(:network, location_id: 1, netzwerk: '192.0.2.0/24') 
    }.to raise_error ActiveRecord::RecordInvalid
  end

  it "creates networks with different location_ids and identical netzwerke" do
    f = FactoryGirl.create(:network, location_id: 1, netzwerk: '192.0.2.0/24')
    g = FactoryGirl.create(:network, location_id: 2, netzwerk: '192.0.2.0/24')
    expect(f).to be_valid
    expect(g).to be_valid
  end

  describe "#netzwerk" do
    let(:netzwerk) { FactoryGirl.create(:network, 
                     location_id: 1, netzwerk: '192.0.2.0/24').netzwerk }

    it "#to_cidr_s shows network in cidr notation" do
      expect(netzwerk.to_cidr_s).to eq "192.0.2.0/24"
    end

    it "#to_cidr_mask shows cidr mask" do
      expect(netzwerk.to_cidr_mask).to eq "24"
    end
  end

  describe "::best_match(ip)" do
    let!(:n1) { FactoryGirl.create(:network, netzwerk: '192.0.2.0/24') }
    let!(:n2) { FactoryGirl.create(:network, netzwerk: '192.0.2.32/27') }
    let!(:n3) { FactoryGirl.create(:network, netzwerk: '192.168.0.0/24') }
    let!(:n4) { FactoryGirl.create(:network, netzwerk: '192.168.0.0/24') }

    it { expect(Network.best_match('192.0.2.35')).to contain_exactly(n2) }
    it { expect(Network.best_match('192.0.2.17')).to contain_exactly(n1) }
    it { expect(Network.best_match('192.168.0.17')).to contain_exactly(n3, n4) }
  end
end
