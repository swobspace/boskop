require 'rails_helper'

RSpec.describe AssignSoftwareJob, type: :job do
  include_context "software_raw_data variables"

  describe "#perform_now" do
    describe "with software_id" do
      it "doesn't update any raw data" do
        expect {
          AssignSoftwareJob.perform_now(software_id: sw1.id)
        }.to change{SoftwareRawDatum.where("software_id IS NOT NULL").count}.by(0)
      end
      it "updates one record with force" do
        expect {
          AssignSoftwareJob.perform_now(software_id: sw1.id, force_update: true)
        }.to change{SoftwareRawDatum.where(software_id: sw1.id).count}.by(1)

        expect(SoftwareRawDatum.pluck(:software_id)).to contain_exactly(
          sw1.id, sw1.id, nil, nil, nil
        )
      end
    end

    describe "without software_id" do
      it "assigns missing software" do
        expect {
          AssignSoftwareJob.perform_now()
        }.to change{SoftwareRawDatum.where("software_id IS NOT NULL").count}.by(2)

        expect(SoftwareRawDatum.pluck(:software_id)).to contain_exactly(
          sw1.id, sw2.id, swzip.id, swzip.id, nil
        )
      end

      it "updates three with force" do
        expect {
          AssignSoftwareJob.perform_now(force_update: true)
        }.to change{SoftwareRawDatum.where("software_id IS NOT NULL").count}.by(2)

        expect(SoftwareRawDatum.pluck(:software_id)).to contain_exactly(
          sw1.id, sw1.id, swzip.id, swzip.id, nil
        )
      end
    end
  end
end
