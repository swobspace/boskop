require 'rails_helper'

RSpec.describe Location, :type => :model do
  it { is_expected.to have_many(:merkmale) }
  it { is_expected.to have_many(:addresses) }
  it { is_expected.to have_many(:networks) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:lid) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:location)
    g = FactoryGirl.create(:location)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of :name
    is_expected.to validate_uniqueness_of :lid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:location, name: "MyName")
    expect("#{f}").to be == "MyName"
  end

  it "to_str returns full name" do
    address = instance_double(Address)
    expect(address).to receive(:ort).and_return("MyOrt")
    f = FactoryGirl.create(:location, name: "MyName", lid: "MyLID")
    expect(f).to receive(:addresses).and_return([address])

    expect("#{f.to_str}").to be == "MyLID / MyName / MyOrt"
  end


end
