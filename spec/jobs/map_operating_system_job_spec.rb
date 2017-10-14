require 'rails_helper'

RSpec.describe CreateOperatingSystemMappingsJob, type: :job do
  let!(:win7) { FactoryGirl.create(:operating_system,
    name: "Windows 7",
    eol: "2020-01-14",
    matching_pattern: "cpe:windows_7\nraw_os:Windows 7",
)}
  let(:host) { FactoryGirl.create(:host,
    ip: '192.0.2.197',
    raw_os: 'Windows 7 Professional',
    cpe: "cpe:/o:microsoft:windows_7::sp1:professional",
)}


  describe "#perform" do
    describe "without :host option" do
      it "raises an error" do
        expect {
          CreateOperatingSystemMappingsJob.perform_now()
        }.to raise_error(ArgumentError)
      end
    end
    describe "with empty :host option" do
      it "raises an error" do
        expect {
          CreateOperatingSystemMappingsJob.perform_now(host: nil)
        }.to raise_error(ArgumentError)
      end
    end

    describe "with new host" do
      let(:job) { CreateOperatingSystemMappingsJob.perform_now(host: host) }
  
      it "creates an operating_system_mapping" do
        expect { job }.to change(OperatingSystemMapping, :count).by(2)
      end
    end
  end

end
