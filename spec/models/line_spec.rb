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
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_inclusion_of(:period_of_notice_unit).
                        in_array(Boskop::PERIOD_UNITS) }
  it { is_expected.to validate_inclusion_of(:renewal_unit).
                        in_array(Boskop::PERIOD_UNITS) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:line)
    g = FactoryGirl.create(:line)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:line, name: 'TDN-NEW-001')
    expect("#{f}").to match("TDN-NEW-001")
  end

  describe "#bandwith" do
    context "with single line (only primary)" do
      let(:line) { FactoryGirl.create(:line, name: 'TDN-XYZ-001',
        bw_downstream: 10,
        bw_upstream: 10,
      )}

      it "returns singular bandwith string" do
        expect(line.bandwith).to match("10.0 Mbit")
      end
      it "returns single bandwith string for asymmetric line" do
        line.bw_upstream = 2
        expect(line.bandwith).to match("10.0/2.0 Mbit")
      end
    end

    context "with secondary line (backup)" do
      let(:line) { FactoryGirl.create(:line, name: 'TDN-XYZ-001',
        bw_downstream: 10,
        bw_upstream: 10,
        bw2_downstream: 2,
        bw2_upstream: 2,
      )}

      it "returns primary/secondary bandwith string" do
        expect(line.bandwith).to match("10.0 Mbit primary + 2.0 Mbit secondary")
      end
      it "returns primary/secondary bandwith string for asymmetric line" do
        line.bw_upstream = 1
        line.bw2_upstream = 0.5
        expect(line.bandwith).to match("10.0/1.0 Mbit primary + 2.0/0.5 Mbit secondary")
      end
    end
  end

  it "#product returns access_type and bandwith" do
    f = FactoryGirl.create(:line, name: 'TDN-NEW-001')
    expect(f).to receive(:access_type).and_return("Ethernet")
    expect(f).to receive(:bandwith).and_return("10 Mbit")
    expect("#{f.product}").to match ("Ethernet 10 Mbit")
  end

end
