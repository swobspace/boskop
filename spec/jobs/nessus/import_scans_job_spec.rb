require 'rails_helper'

RSpec.shared_examples "a importable scan" do
  it "doesn't raise an error" do
    expect {
      subject
    }.not_to raise_error
  end
  it "creates an host" do
    expect {
      subject
    }.to change{Host.count}.by(1)
  end
  it "creates 27 vulnerabilities" do
    expect {
      subject
    }.to change(Vulnerability, :count).by(27)
  end
  it "creates 27 vulnerability_details" do
    expect {
      subject
    }.to change{VulnerabilityDetail.count}.by(27)
  end
end

RSpec.shared_examples "a non-importable scan" do
  it "doesn't raise an error" do
    expect {
      subject
    }.not_to raise_error
  end
  it "does not create an host" do
    expect {
      subject
    }.to change{Host.count}.by(0)
  end
  it "does not create vulnerabilities" do
    expect {
      subject
    }.to change(Vulnerability, :count).by(0)
  end
  it "does not create vulnerability_details" do
    expect {
      subject
    }.to change{VulnerabilityDetail.count}.by(0)
  end
end

RSpec.describe Nessus::ImportScansJob, type: :job do
  DLresult = ImmutableStruct.new( :success?, :error_message, :xmlfile )
  subject { Nessus::ImportScansJob.perform_now }

  # let(:DLresult) { ImmutableStruct.new( :success?, :error_message, :xmlfile ) }
  let(:dlresult) {
    FileUtils.cp(
      File.join(Rails.root, 'spec', 'fixtures', 'files', 'netxp-nessus.xml'),
      xmlfile)
    DLresult.new(success: true, error_message: nil, xmlfile: xmlfile)
   }

  let(:nessus_scan) { FactoryBot.create(:nessus_scan,
    uuid: "9608eba4-b33d-11e8-82aa-2387b3c5dd08",
    name: "XYZ default",
    nessus_id: "1234567",
    last_modification_date: 1.day.before(Date.today),
  )}
  let(:xmlfile) { File.join(Rails.root, 'tmp', "#{nessus_scan.uuid}.nessus") }

  describe "#perform" do
    describe "valid imports" do
      before(:each) do
       dlsvc = instance_double(DownloadNessusScanService)
       expect(DownloadNessusScanService).to receive(:new).with(any_args).and_return(dlsvc)
       expect(dlsvc).to receive(:call).and_return(dlresult)
      end

      describe "with import_mode: auto" do
	before(:each) do
	  nessus_scan.update(import_mode: 'auto', import_state: 'new', status: 'completed')
	end
	it_behaves_like "a importable scan"
      end

      describe "with import_mode: manual" do
	subject { Nessus::ImportScansJob.perform_now(import_mode: 'manual') }
	before(:each) do
	  nessus_scan.update(import_mode: 'manual', import_state: 'new', status: 'completed')
	end
	it_behaves_like "a importable scan"
      end

      describe "with given nessus_id" do
	subject { Nessus::ImportScansJob.perform_now(nessus_id: '1234567') }
	before(:each) do
	  nessus_scan.update(import_mode: 'manual', import_state: 'new', status: 'completed')
	end
	it_behaves_like "a importable scan"
      end
    end

    describe "no imports on" do
      describe "import_mode: unassigned, import_state: new" do
	before(:each) do
	  nessus_scan.update(import_mode: 'unassigned', import_state: 'new', status: 'completed')
	end
	it_behaves_like "a non-importable scan"
      end

      describe "import_mode: ignore, import_state: new" do
	before(:each) do
	  nessus_scan.update(import_mode: 'ignore', import_state: 'new', status: 'completed')
	end
	it_behaves_like "a non-importable scan"
      end

      describe "import_mode: auto, import_state: done" do
	before(:each) do
	  nessus_scan.update(import_mode: 'auto', import_state: 'done', status: 'completed')
	end
	it_behaves_like "a non-importable scan"
      end

      describe "import_mode: manual, import_state: done" do
	subject { Nessus::ImportScansJob.perform_now(import_mode: 'manual') }
	before(:each) do
	  nessus_scan.update(import_mode: 'manual', import_state: 'done', status: 'completed')
	end
	it_behaves_like "a non-importable scan"
      end

      describe "import_mode: auto, status: running" do
	before(:each) do
	  nessus_scan.update(import_mode: 'auto', import_state: 'new', status: 'running')
	end
	it_behaves_like "a non-importable scan"
      end

      describe "import_mode: manual, status: running" do
	subject { Nessus::ImportScansJob.perform_now(import_mode: 'manual') }
	before(:each) do
	  nessus_scan.update(import_mode: 'manual', import_state: 'new', status: 'running')
	end
	it_behaves_like "a non-importable scan"
      end

    end
  end
end
