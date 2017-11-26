require 'rails_helper'

RSpec.describe OrgUnit, :type => :model do
  it { is_expected.to have_many(:merkmale) }
  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryBot.create(:org_unit)
    g = FactoryBot.create(:org_unit)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of :name
  end

  it "to_s returns value" do
    f = FactoryBot.create(:org_unit, name: "MyName")
    expect("#{f}").to be == "MyName"
  end


end
