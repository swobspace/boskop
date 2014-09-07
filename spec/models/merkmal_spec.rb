require 'rails_helper'

RSpec.describe Merkmal, :type => :model do
  it { is_expected.to belong_to(:merkmalklasse) }
  it { is_expected.to belong_to(:merkmalfor) }
  it { is_expected.to validate_presence_of(:merkmalklasse_id) }
  it { is_expected.to validate_presence_of(:merkmalfor_id) }
  it { is_expected.to validate_presence_of(:merkmalfor_type) }

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

end
