require 'rails_helper'

RSpec.describe Merkmalklasse, :type => :model do
  it { is_expected.to have_many(:merkmale) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:format) }
  it { is_expected.to validate_inclusion_of(:format).in_array(Merkmalklasse::FORMATE) }
  it { is_expected.to validate_presence_of(:position) }
  it { is_expected.to validate_presence_of(:for_object) }
  it { is_expected.to validate_inclusion_of(:for_object).in_array(Merkmalklasse::OBJECTS) }
  it { is_expected.to serialize(:possible_values).as(Array) }

  it { is_expected.to validate_presence_of(:visible) }
  it { is_expected.to serialize(:visible).as(Array) }
  it { pending "don't know how to do this"
       is_expected.to validate_inclusion_of(:visible).in_array(Merkmalklasse::VISIBLES) }
  it { is_expected.to allow_value('http://foo.com', 'https://bar.com/baz').
       for(:baselink) }
  it { is_expected.not_to allow_value('foo.com', 'https:baz').for(:baselink) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:merkmalklasse)
    g = FactoryGirl.create(:merkmalklasse)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of(:name).scoped_to(:for_object)
  end

  it "to_s returns name" do
    f = FactoryGirl.create(:merkmalklasse, name: "MyName")
    expect("#{f}").to be == "MyName"
  end

  it "returns visible merkmalklasse for :index" do
    f = FactoryGirl.create(:merkmalklasse, visible: ['index'], for_object: 'Location')
    g = FactoryGirl.create(:merkmalklasse, visible: [''], for_object: 'Location')
    expect(Merkmalklasse.visibles(:location, 'index')).to include(f)
    expect(Merkmalklasse.visibles(:location, 'index')).not_to include(g)
  end

end
