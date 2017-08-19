require 'rails_helper'

RSpec.describe AccessType, type: :model do
  it { is_expected.to have_many(:lines) }

  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:access_type)
    g = FactoryGirl.create(:access_type)
    expect(g).to validate_uniqueness_of(:name)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:access_type, name: 'SuperDSL')
    expect("#{f}").to match ("SuperDSL")
  end

  [:line].each do |what|
    it "should not destroyable if dependent #{what} exist" do
      at   = FactoryGirl.create(:access_type)
      subj = FactoryGirl.create(what, access_type: at)
      expect {
        at.destroy
      }.not_to change { AccessType.count }
    end

    it "should be destroyable if no dependent #{what} exist" do
      at = FactoryGirl.create(:access_type)
      expect {
        at.destroy
      }.to change { AccessType.count }.by(-1)
    end
  end

end
