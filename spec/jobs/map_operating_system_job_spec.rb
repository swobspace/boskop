require 'rails_helper'

RSpec.describe MapOperatingSystemJob, type: :job do
  let!(:win7) { FactoryGirl.create(:operating_system,
    name: "Windows 7",
    eol: "2020-01-14",
    matching_pattern: "cpe:windows_7\nraw_os:Windows 7",
)}
  let(:host) { FactoryGirl.create(:host,
    ip: '192.0.2.197',
    raw_os: 'Windows 7 Professional',
    cpe: "/o:microsoft:windows_7::sp1:professional",
)}


  describe "#perform" do
    describe "without :host option" do
      it "raises an error" do
        expect {
          MapOperatingSystemJob.perform_now()
        }.to raise_error(ArgumentError)
      end
    end
    describe "with empty :host option" do
      it "raises an error" do
        expect {
          MapOperatingSystemJob.perform_now(host: nil)
        }.to raise_error(ArgumentError)
      end
    end

    describe "with new host" do
      let(:job) { MapOperatingSystemJob.perform_now(host: host) }
  
      it "creates an operating_system_mapping" do
        expect { job }.to change(OperatingSystemMapping, :count).by(2)
      end
      context "executing job" do
        before(:each) do
          job
        end
        it { expect(OperatingSystemMapping.first.operating_system).to eq(win7) }
        it { expect(OperatingSystemMapping.last.operating_system).to eq(win7) }
        it { expect(host.operating_system).to eq(win7) }
      end
    end
  end

end
