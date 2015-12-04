require 'rails_helper'

RSpec.describe FrameworkContract, type: :model do
 it { is_expected.to have_many(:lines) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:framework_contract)
    g = FactoryGirl.create(:framework_contract)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:framework_contract, name: 'myRahmenvertrag')
    expect("#{f}").to match ("myRahmenvertrag")
  end

  [:line].each do |what|
    it "should not destroyable if dependent #{what} exist" do
      fc   = FactoryGirl.create(:framework_contract)
      subj = FactoryGirl.create(what, framework_contract: fc)
      expect {
        fc.destroy
      }.not_to change { AccessType.count }
    end

    it "should be destroyable if no dependent #{what} exist" do
      fc = FactoryGirl.create(:framework_contract)
      expect {
        fc.destroy
      }.to change { AccessType.count }.by(-1)
    end
  end

end
