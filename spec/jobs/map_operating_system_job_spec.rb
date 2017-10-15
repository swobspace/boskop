require 'rails_helper'

RSpec.describe MapOperatingSystemJob, type: :job do
  let!(:xp) { FactoryGirl.create(:operating_system,
    name: 'Windows XP',
    eol: '2014-04-08',
    matching_pattern: "cpe:windows_xp\nraw_os:Windows 5.1\nraw_os:Windows XP"
  )}
  let!(:win7) { FactoryGirl.create(:operating_system,
    name: "Windows 7",
    eol: "2020-01-14",
    matching_pattern: "cpe:windows_7\nraw_os:Windows 7",
)}
  let(:host) { FactoryGirl.create(:host,
    ip: '192.0.2.197',
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

    describe "new host with :raw_os" do
      let(:raw_hash) {{ raw_os: 'Windows 7 Professional' }}
      let(:job) { MapOperatingSystemJob.perform_now(host: host) }
      before(:each) do
        host.update(raw_hash)
      end
  
      it "creates an operating_system_mapping" do
	expect { job }.to change(OperatingSystemMapping, :count).by(1)
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

    describe "new host with :cpe" do
      let(:raw_hash) {{ cpe: "/o:microsoft:windows_7::sp1:professional" }}
      let(:job) { MapOperatingSystemJob.perform_now(host: host) }
      before(:each) do
        host.update(raw_hash)
      end
  
      it "creates an operating_system_mapping" do
	expect { job }.to change(OperatingSystemMapping, :count).by(1)
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

    describe "old host with updated :raw_os" do
      let(:job) { MapOperatingSystemJob.perform_now(host: host, fields: [:raw_os]) }
      before(:each) do
        host.update(operating_system: xp, 
                    cpe: "cpe:/o:microsoft:windows_xp::-")
        host.update(raw_os: 'Windows 7 Professional')
      end
  
      it "creates an operating_system_mapping" do
	expect { job }.to change(OperatingSystemMapping, :count).by(1)
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

    describe "old host with updated :cpe" do
      let(:job) { MapOperatingSystemJob.perform_now(host: host, fields: [:cpe]) }
      before(:each) do
        host.update(operating_system: xp, 
                    raw_os: "Windows 5.1")
        host.update(cpe: "/o:microsoft:windows_7::sp1:professional")
      end
  
      it "creates an operating_system_mapping" do
	expect { job }.to change(OperatingSystemMapping, :count).by(1)
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
