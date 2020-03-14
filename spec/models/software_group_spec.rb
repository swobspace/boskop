require 'rails_helper'

RSpec.describe SoftwareGroup, type: :model do
  it { is_expected.to have_many(:software_categories) }
  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryBot.create(:software_group)
    g = FactoryBot.create(:software_group)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of :name
  end

  it "to_s returns value" do
    f = FactoryBot.create(:software_group, name: "SomeGroup")
    expect("#{f}").to be == "SomeGroup"
  end


end
