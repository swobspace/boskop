require 'rails_helper'

RSpec.describe OperatingSystem, type: :model do
  it { is_expected.to have_many(:hosts) }
  it { is_expected.to have_many(:operating_system_mappings) }
  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:operating_system)
    g = FactoryGirl.create(:operating_system)
    expect(f).to validate_uniqueness_of(:name)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:operating_system, name: 'My Special OS')
    expect("#{f}").to match ("My Special OS")
  end

end
