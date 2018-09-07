require 'rails_helper'

RSpec.describe NessusScan, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:uuid) }
  it { is_expected.to validate_presence_of(:nessus_id) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:last_modification_date) }

  it "should get plain factory working" do
    f = FactoryBot.create(:nessus_scan)
    g = FactoryBot.create(:nessus_scan)
    expect(f).to validate_uniqueness_of(:uuid)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryBot.create(:nessus_scan, name: 'XYZ default', nessus_id: '1234',
                          last_modification_date: Date.today)
    expect("#{f}").to match ("1234 / XYZ default / #{Date.today.to_s}")
  end

end
