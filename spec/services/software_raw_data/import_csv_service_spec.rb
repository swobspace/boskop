require 'rails_helper'

module SoftwareRawData
  RSpec.describe ImportCsvService do
    let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'raw_software.csv') }
    subject { ImportCsvService.new(file: csvfile, 
                                   lastseen: Date.parse('2020-03-03'),
                                   source: "docusnap") }

    # check for class methods
    it { expect(ImportCsvService.respond_to? :new).to be_truthy}

    # check for instance methods
    describe "instance methods" do
      subject { ImportCsvService.new(file: "") }
      it { expect(subject.respond_to? :call).to be_truthy}
      it { expect(subject.call.respond_to? :success?).to be_truthy }
      it { expect(subject.call.respond_to? :error_message).to be_truthy }
      it { expect(subject.call.respond_to? :software_raw_data).to be_truthy }
    end

    describe "#call" do

      context "with valid import_attributes" do
        it "creates an SoftwareRawDatum" do
          expect {
            subject.call
          }.to change{SoftwareRawDatum.count}.by(4)
        end

        describe "#call" do
          let(:result) { subject.call }
          it { expect(result.success?).to be_truthy }
          it { expect(result.error_message.present?).to be_falsey }
          it { expect(result.software_raw_data).to be_a_kind_of Array }

          describe "the first software_raw_datum" do
            let!(:swr) { result.software_raw_data.first }
            it { expect(swr).to be_a_kind_of SoftwareRawDatum }
            it { expect(swr).to be_persisted }
            it { expect(swr.name.to_s).to eq("7-Zip 19.00") }
            it { expect(swr.version).to eq("19.00") }
            it { expect(swr.vendor).to eq("Igor Pavlov") }
            it { expect(swr.count).to eq(77) }
            it { expect(swr.operating_system).to eq("Windows") }
            it { expect(swr.lastseen.to_s).to match(/2020-03-03/) }
            it { expect(swr.source).to eq("docusnap") }
          end
        end
      end

      context "with german header values" do
        let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'docusnap.csv') }
        it "creates 4 SoftwareRawData" do
          expect {
            subject.call
          }.to change{SoftwareRawDatum.count}.by(4)
        end
        describe "the first software_raw_datum" do
          let(:result) { subject.call }
          let!(:swr) { result.software_raw_data.first }
          it { expect(swr).to be_a_kind_of SoftwareRawDatum }
          it { expect(swr).to be_persisted }
          it { expect(swr.name.to_s).to eq("7-Zip 19.00") }
          it { expect(swr.version).to eq("19.00") }
          it { expect(swr.vendor).to eq("Igor Pavlov") }
          it { expect(swr.count).to eq(77) }
          it { expect(swr.operating_system).to eq("Windows") }
          it { expect(swr.lastseen.to_s).to match(/2020-03-03/) }
          it { expect(swr.source).to eq("docusnap") }
        end
      end

      context "with invalid import_attributes" do
        subject { ImportCsvService.new(file: "") }

        it "creates an SoftwareRawDatum" do
          expect {
            subject.call
          }.to change{SoftwareRawDatum.count}.by(0)
        end

        describe "#call" do
          let(:result) { subject.call }
          it { expect(result.success?).to be_falsey }
          it { expect(result.error_message.present?).to be_truthy }
          it { expect(result.software_raw_data.first).to be_nil }
        end
      end

      context "with extended software raw data (containing host installations)" do
        let!(:pc1){FactoryBot.create(:host, name: 'PC41', serial: 'YL3M104238') }
        let!(:pc2){FactoryBot.create(:host, name:'PC453', serial: '3H4FZ72') }
        let!(:pc3){FactoryBot.create(:host, name:'PC461', serial: '822XJ52') }
                     
        let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'swr_extended.csv') }
        subject { ImportCsvService.new(file: csvfile, 
                                       source: "docusnap") }

        it "creates 3 SoftwareRawData" do
          expect {
            subject.call
          }.to change{SoftwareRawDatum.count}.by(3)
        end
      
        it "creates 5 InstalledSoftware entries" do
          expect {
            subject.call
          }.to change{InstalledSoftware.count}.by(4)
        end

        describe "the first software_raw_datum" do
          let(:result) { subject.call }
          let!(:swr) { result.software_raw_data.first }
          it { expect(swr).to be_a_kind_of SoftwareRawDatum }
          it { expect(swr).to be_persisted }
          it { expect(swr.name.to_s).to eq("Java 7 Update 55") }
          it { expect(swr.version).to eq("7.0.550") }
          it { expect(swr.vendor).to eq("Oracle") }
          it { expect(swr.operating_system).to eq("Windows") }
          it { expect(swr.lastseen.to_s).to match(/#{Date.today}/) }
          it { expect(swr.source).to eq("docusnap") }
        end
      end
    end

    describe "with existing software_raw_datum" do
      let(:result) { subject.call }
      let!(:swr) { FactoryBot.create(:software_raw_datum,
        "name" => "7-Zip 19.00",
        "version" => "19.00",
        "vendor" => "Igor Pavlov",
        "count" => "5",
        "operating_system" => "Windows",
        "lastseen" => "2020-02-29",
        "source" => "docusnap",
      )}
      let(:swr_new) { result.software_raw_data }
      it { expect(result.success?).to be_truthy }
      it { expect(result.error_message.present?).to be_falsey }
      it { expect(swr_new.first).to be_kind_of SoftwareRawDatum }
      it { expect(swr_new.pluck(:name)).to contain_exactly(
             "7-Zip 19.00", 
             "7-Zip 19.00 (x64 edition)", 
             "7-Zip 19.00 (x64)", 
             "7-Zip 19.02 alpha (x64)"
         )}
      it { expect(swr_new.pluck(:version)).to contain_exactly(
             "19.00",
             "19.00.00.0",
             "19.00",
             "19.02 alpha",
         )}
      it { expect(swr_new.pluck(:vendor)).to contain_exactly(
             "Igor Pavlov",
             "Igor Pavlov",
             "Igor Pavlov",
             "Igor Pavlov",
         )}
      it { expect(swr_new.pluck(:count)).to contain_exactly(
             77,
             25,
             80,
             2,
         )}
      it { expect(swr_new.pluck(:operating_system)).to contain_exactly(
             "Windows",
             "Windows",
             "Windows",
             "Windows",
         )}
      it { expect(swr_new.pluck(:lastseen).map(&:to_s)).to contain_exactly(
             "2020-03-03",
             "2020-03-03",
             "2020-03-03",
             "2020-03-13"
         )}
    end

    context "with blank and empty fields" do
      subject { ImportCsvService.new(file: csvfile, lastseen: Date.parse('2020-03-03')) }
      let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'empty_fields.csv') }
      let(:swr) { subject.call.software_raw_data.first }
      it { expect(swr.name).to eq("mySoftware") }
      it { expect(swr.version).to eq("") }
      it { expect(swr.vendor).to eq("") }
      it { expect(swr.source).to eq("") }
    end
  end
end
