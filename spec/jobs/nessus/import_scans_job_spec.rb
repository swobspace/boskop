require 'rails_helper'

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

  let!(:nessus_scan) { FactoryBot.create(:nessus_scan,
    uuid: "9608eba4-b33d-11e8-82aa-2387b3c5dd08",
    name: "XYZ default",
    nessus_id: "1234567",
    status: "running",
    last_modification_date: 1.day.before(Date.today),
    import_state: 'new'
  )}
  let(:xmlfile) { File.join(Rails.root, 'tmp', "#{nessus_scan.uuid}.nessus") }

  describe "#perform" do
    before(:each) do
      dlsvc = instance_double(DownloadNessusScanService)
      expect(DownloadNessusScanService).to receive(:new).with(any_args).and_return(dlsvc)
      expect(dlsvc).to receive(:call).and_return(dlresult)
    end

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

    it "creates 5 vulnerabilities" do
      expect {
        subject
      }.to change(Vulnerability, :count).by(5)
    end

    it "creates 5 vulnerability_details" do
      expect {
        subject
      }.to change{VulnerabilityDetail.count}.by(5)
    end

  end
end
