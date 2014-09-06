require 'rails_helper'

RSpec.describe Merkmalklasse, :type => :model do
  # it { is_expected.to have_many(:merkmale) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:format) }
  it { is_expected.to validate_inclusion_of(:format).in_array(Merkmalklasse::FORMATE) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:merkmalklasse)
    g = FactoryGirl.create(:merkmalklasse)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of :name
  end

  it "to_s returns name" do
    f = FactoryGirl.create(:merkmalklasse, name: "MyName")
    expect("#{f}").to be == "MyName"
  end

end
