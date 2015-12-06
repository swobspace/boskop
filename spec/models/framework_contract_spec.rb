require 'rails_helper'

RSpec.describe FrameworkContract, type: :model do
 it { pending "line not yet implemented"; is_expected.to have_many(:lines) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_inclusion_of(:period_of_notice_unit).
                        in_array(Boskop::PERIOD_UNITS) }
  it { is_expected.to validate_inclusion_of(:renewal_unit).
                        in_array(Boskop::PERIOD_UNITS) }

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
      pending "line not yet implemented"
      subj = FactoryGirl.create(what, framework_contract: fc)
      expect {
        fc.destroy
      }.not_to change { AccessType.count }
    end

    it "should be destroyable if no dependent #{what} exist" do
      fc = FactoryGirl.create(:framework_contract)
      pending "line not yet implemented"
      expect {
        fc.destroy
      }.to change { AccessType.count }.by(-1)
    end
  end

end
