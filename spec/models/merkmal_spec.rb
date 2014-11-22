require 'rails_helper'

RSpec.describe Merkmal, :type => :model do
  let(:location)  { FactoryGirl.create(:location) }
  let(:location2) { FactoryGirl.create(:location) }

  it { is_expected.to belong_to(:merkmalklasse) }
  it { is_expected.to belong_to(:merkmalfor) }
  it { is_expected.to validate_presence_of(:merkmalklasse_id) }
  # it { is_expected.to validate_presence_of(:merkmalfor_id) }
  # it { is_expected.to validate_presence_of(:merkmalfor_type) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:merkmal)
    g = FactoryGirl.create(:merkmal)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:merkmal, value: "MyName")
    expect("#{f}").to be == "MyName"
  end

  it "allows only one merkmal of the same merkmalklasse on the same object" do
    mk = FactoryGirl.create(:merkmalklasse, for_object: "Location", unique: true)
    f = FactoryGirl.create(:merkmal, merkmalklasse: mk, merkmalfor: location,
                                     value: "Name1")
    expect(f).to be_valid

    expect {
      FactoryGirl.create(:merkmal, merkmalklasse: mk, merkmalfor: location,
                                   value: "Name2")
    }.to raise_error(ActiveRecord::RecordNotSaved)
  end

  it "respects uniqueness of value" do
    mk = FactoryGirl.create(:merkmalklasse, for_object: "Location", unique: true)
    f = FactoryGirl.create(:merkmal, merkmalklasse: mk, merkmalfor: location,
                                     value: "Name1")
    g = FactoryGirl.build(:merkmal, merkmalklasse: mk, merkmalfor: location2,
                                     value: "Name1")
    expect(f).to be_valid
    expect(g).to be_invalid
  end

  it "allows duplicate merkmale with same value if merkmalklasse is not uniq" do
    mk = FactoryGirl.create(:merkmalklasse, for_object: "Location", unique: false)
    f = FactoryGirl.create(:merkmal, merkmalklasse: mk, merkmalfor: location,
                                     value: "Name1")
    g = FactoryGirl.create(:merkmal, merkmalklasse: mk, merkmalfor: location2,
                                     value: "Name1")
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "forces value if merkmalklasse is mandantory" do
    mk = FactoryGirl.create(:merkmalklasse, for_object: "Location", mandantory: true)
    f = FactoryGirl.build(:merkmal, merkmalklasse: mk, merkmalfor: location, value: nil)
    expect(f).to be_invalid
  end

  it "allows empty value if merkmalklasse is optional" do
    mk = FactoryGirl.create(:merkmalklasse, for_object: "Location", mandantory: false)
    f = FactoryGirl.create(:merkmal, merkmalklasse: mk, merkmalfor: location, value: nil)
    expect(f).to be_valid
  end

end
