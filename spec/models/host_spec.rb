require 'rails_helper'

RSpec.describe Host, type: :model do
  it { is_expected.to belong_to(:host_category) }
  it { is_expected.to belong_to(:location) }
  it { is_expected.to validate_presence_of(:ip) }
  it { is_expected.to validate_presence_of(:lastseen) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:host)
    g = FactoryGirl.create(:host)
    expect(f).to validate_uniqueness_of(:ip)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:host, ip: '192.0.2.77', name: 'anyhost')
    expect("#{f}").to match ("192.0.2.77 (anyhost)")
  end

end
