require 'rails_helper'

RSpec.describe Network, :type => :model do
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
end
