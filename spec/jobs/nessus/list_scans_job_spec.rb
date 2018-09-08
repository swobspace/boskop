require 'rails_helper'

RSpec.describe Nessus::ListScansJob, type: :job do
  subject { Nessus::ListScansJob.perform_now }
  let(:scanlist) {{
    "folders" => [],
    "scans" => [
      { "uuid" => "5c7b8a51-b463-8a0b-f975-5e3ce36a35792a10a517152c7296",
        "name" => "XYZ default",
        "id" => "1234567",
        "status" => "completed",
        "last_modification_date" => Time.now
      }
    ],
    "timestamp" => Time.now
  }}

  before(:each) do
    nscan = instance_double(TenableRuby::Client)
    expect(TenableRuby::Client).to receive(:new).with(any_args).and_return(nscan)
    expect(nscan).to receive(:authenticate).and_return(true)
    expect(nscan).to receive(:scan_list).and_return(scanlist)
  end

  describe "#perform" do
    it "doesn't raise an error" do
      expect {
        subject
      }.not_to raise_error
    end

    describe "with a test scan" do
      let(:scanlist) {{
	"folders" => [],
	"scans" => [
	  { "uuid" => "5c7b8a51-b463-8a0b-f975-5e3ce36a35792a10a517152c7296",
	    "name" => "XYZ TeST bla",
	    "id" => "1234567",
	    "status" => "completed",
	    "last_modification_date" => Time.now
	  }
	],
	"timestamp" => Time.now
      }}

      it "does not create a NessusScan" do
	expect {
	  subject
	}.to change(NessusScan, :count).by(0)
      end
    end

    describe "with new scan" do
      it "creates a new NessusScan entry" do
	expect {
	  subject
	}.to change(NessusScan, :count).by(1)
      end

      it "creates a new NessusScan entry" do
        job = subject
        expect(NessusScan.first.uuid).to eq("5c7b8a51-b463-8a0b-f975-5e3ce36a35792a10a517152c7296")
      end
    end

    describe "with an existing scan" do
      let!(:nessus_scan) { FactoryBot.create(:nessus_scan,
        uuid: "9608eba4-b33d-11e8-82aa-2387b3c5dd08",
        name: "XYZ default",
        nessus_id: "1234567",
        status: "running",
        last_modification_date: 1.day.before(Date.today),
        import_state: 'done'
      )}
      it "creates no new NessusScan entry" do
	expect {
	  subject
	}.to change(NessusScan, :count).by(0)
      end

      it "updates entry" do
        job = subject
        expect(NessusScan.first.uuid).to eq("5c7b8a51-b463-8a0b-f975-5e3ce36a35792a10a517152c7296")
        expect(NessusScan.first.status).to eq("completed")
        expect(NessusScan.first.nessus_id).to eq("1234567")
        expect(NessusScan.first.import_state).to eq("new")
      end
    end
  end 
end
