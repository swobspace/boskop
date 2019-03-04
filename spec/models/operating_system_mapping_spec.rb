require 'rails_helper'

RSpec.describe OperatingSystemMapping, type: :model do
  it { is_expected.to belong_to(:operating_system).optional }
  it { is_expected.to validate_presence_of(:field) }
  it { is_expected.to validate_presence_of(:value) }

  it "should get plain factory working" do
    f = FactoryBot.create(:operating_system_mapping)
    g = FactoryBot.create(:operating_system_mapping)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns field:value" do
    f = FactoryBot.create(:operating_system_mapping, field: 'cpe', value: '12345')
    expect("#{f}").to match ("cpe:12345")
  end

end
