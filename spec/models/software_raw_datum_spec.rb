require 'rails_helper'

RSpec.describe SoftwareRawDatum, type: :model do
  it { is_expected.to belong_to(:software).optional }

  it "should get plain factory working" do
    f = FactoryBot.create(:software_raw_datum)
    g = FactoryBot.create(:software_raw_datum)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of(:name).scoped_to(:vendor, :version, :operating_system)
  end

  it "to_s returns value" do
    f = FactoryBot.create(:software_raw_datum, name: "HotSoftware", vendor: "SpecialPartner")
    expect("#{f}").to be == "HotSoftware (SpecialPartner)"
  end

end
