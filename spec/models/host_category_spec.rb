require 'rails_helper'

RSpec.describe HostCategory, type: :model do
  it { is_expected.to have_many(:hosts) }
  it { is_expected.to have_many(:vulnerabilities).through(:hosts) }
  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:host_category)
    g = FactoryGirl.create(:host_category)
    expect(f).to validate_uniqueness_of(:name)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:host_category, name: 'Saturn')
    expect("#{f}").to match ("Saturn")
  end
end
