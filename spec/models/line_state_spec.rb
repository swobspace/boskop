require 'rails_helper'

RSpec.describe LineState, type: :model do
 it { pending "line not yet implemented"; is_expected.to have_many(:lines) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:line_state)
    g = FactoryGirl.create(:line_state)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:line_state, name: 'in usage')
    expect("#{f}").to match ("in usage")
  end

  [:line].each do |what|
    it "should not destroyable if dependent #{what} exist" do
      ls   = FactoryGirl.create(:line_state)
      pending "line not yet implemented"
      subj = FactoryGirl.create(what, line_state: ls)
      expect {
        ls.destroy
      }.not_to change { AccessType.count }
    end

    it "should be destroyable if no dependent #{what} exist" do
      ls = FactoryGirl.create(:line_state)
      pending "line not yet implemented"
      expect {
        ls.destroy
      }.to change { AccessType.count }.by(-1)
    end
  end

end
