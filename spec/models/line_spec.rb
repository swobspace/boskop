require 'rails_helper'

RSpec.describe Line, type: :model do
  it { is_expected.to belong_to(:line_state) }
  it { is_expected.to belong_to(:access_type) }
  it { is_expected.to belong_to(:framework_contract) }
  it { is_expected.to belong_to(:location_a) }
  it { is_expected.to belong_to(:location_b) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:location_a_id) }
  it { is_expected.to validate_presence_of(:access_type_id) }
  it { is_expected.to validate_presence_of(:line_state_id) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_inclusion_of(:period_of_notice_unit).
                        in_array(Boskop::PERIOD_UNITS) }
  it { is_expected.to validate_inclusion_of(:renewal_unit).
                        in_array(Boskop::PERIOD_UNITS) }

  it "should get plain factory working" do
    f = FactoryBot.create(:line)
    g = FactoryBot.create(:line)
    expect(f).to validate_uniqueness_of(:name)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryBot.create(:line, name: 'TDN-NEW-001')
    expect("#{f}").to match ("TDN-NEW-001")
  end

end
