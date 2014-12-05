require 'rails_helper'

RSpec.describe Network, :type => :model do
  it { is_expected.to belong_to(:location) }

  it { is_expected.to validate_presence_of(:name) }
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

end
