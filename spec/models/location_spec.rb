require 'rails_helper'

RSpec.describe Location, :type => :model do
  it { is_expected.to have_many(:merkmale) }

  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:location)
    g = FactoryGirl.create(:location)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of :name
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:location, name: "MyName")
    expect("#{f}").to be == "MyName"
  end

end
