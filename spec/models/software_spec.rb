require 'rails_helper'

RSpec.describe Software, type: :model do
  it { is_expected.to have_many(:software_raw_data) }
  it { is_expected.to belong_to(:software_category).optional }
  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryBot.create(:software)
    g = FactoryBot.create(:software)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of :name
  end

  it "to_s returns value" do
    f = FactoryBot.create(:software, name: "HotSoftware", vendor: "SpecialPartner")
    expect("#{f}").to be == "HotSoftware (SpecialPartner)"
  end


end
