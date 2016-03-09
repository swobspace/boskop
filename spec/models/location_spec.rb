require 'rails_helper'

RSpec.describe Location, :type => :model do
  let(:location) { FactoryGirl.create(:location, name: "MyName", lid: "MyLID") }
  let(:address)  { FactoryGirl.create(:address,
    ort: "MyOrt",
    plz: "12345",
    streetaddress: "Einweg 15",
  )}
  let(:address2) { FactoryGirl.create(:address,
    ort: "Remote",
    plz: "67890",
    streetaddress: "Holzweg 4",
  )}

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
    expect("#{location}").to be == "MyName"
  end

  describe "with 2 addresses" do
    before(:each) do
      location.addresses << address
      location.addresses << address2
    end

    describe "using first address" do
      it "to_str returns full name" do
	expect("#{location.to_str}").to be == "MyLID / MyName / 12345 MyOrt"
      end

      it "to_string returns full name including address" do
	expect("#{location.to_string}").to be == "MyLID / MyName / 12345 MyOrt, Einweg 15"
      end

      it { expect(location.plz).to match("12345") }
      it { expect(location.ort).to match("MyOrt") }
      it { expect(location.streetaddress).to match("Einweg 15") }
    end

    describe "using second address" do
      it "to_str returns full name" do
	expect("#{location.to_str(1)}").to be == "MyLID / MyName / 67890 Remote"
      end

      it "to_string returns full name including address" do
	expect("#{location.to_string(1)}").to be == "MyLID / MyName / 67890 Remote, Holzweg 4"
      end

      it { expect(location.plz(1)).to match("67890") }
      it { expect(location.ort(1)).to match("Remote") }
      it { expect(location.streetaddress(1)).to match("Holzweg 4") }
    end
  end
end
