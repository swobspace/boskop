require 'rails_helper'

RSpec.describe ImportNmapXmlService do
    let(:nmapxml) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'smb-os-discovery-42.xml') }

  # check for class methods
  it { expect(ImportNmapXmlService.respond_to? :new).to be_truthy}

  # check for instance methods
  describe "instance methods" do
    subject { ImportNmapXmlService.new(file: "") }
    it { expect(subject.respond_to? :call).to be_truthy}
    it { expect(subject.call.respond_to? :success?).to be_truthy }
    it { expect(subject.call.respond_to? :error_message).to be_truthy }
    it { expect(subject.call.respond_to? :hosts).to be_truthy }
  end

  describe "#call" do
    subject { ImportNmapXmlService.new(file: nmapxml) }

    it "calls Host.create" do
      host = instance_double(Host)
      expect(Host).to receive_message_chain(:create_with, :find_or_create_by).with(any_args).and_return(host)
      expect(host).to receive(:persisted?).and_return(false)
      allow(host).to receive_message_chain(:errors, :any?).and_return(true)
      allow(host).to receive_message_chain(:errors, :messages).and_return(["a", "b"])
      subject.call
    end

    context "with valid import_attributes" do
      it "creates an Host" do
	expect {
	  subject.call
	}.to change{Host.count}.by(1)
      end

      describe "#call" do
        let(:result) { subject.call }
        it { expect(result.success?).to be_truthy }
        it { expect(result.error_message.present?).to be_falsey }
        it { expect(result.hosts).to be_a_kind_of Array }

        describe "the first host" do
          let(:host) { result.hosts.first }
          it { expect(host).to be_a_kind_of Host }
          it { expect(host).to be_persisted }
          it { expect(host.ip.to_s).to eq("192.168.1.42") }
          it { expect(host.lastseen.to_s).to match(/\A2017-08-20/) }
          it { expect(host.name).to eq("wob42") }
          it { expect(host.mac).to eq("C8:FF:28:78:29:DB") }
          it { expect(host.cpe).to eq("cpe:/o:microsoft:windows_10::-") }
          it { expect(host.raw_os).to eq("Windows 10 Pro 15063") }
          it { expect(host.fqdn).to eq("DESKTOP-6GLIL73") }
          it { expect(host.workgroup).to eq("WORKGROUP") }
          it { expect(host.domain_dns).to eq("DESKTOP-6GLIL73") }
        end
      end
    end

    context "with invalid import_attributes" do
      subject { ImportNmapXmlService.new(file: "") }

      it "creates an Host" do
	expect {
	  subject.call
	}.to change{Host.count}.by(0)
      end

      describe "#call" do
        let(:result) { subject.call }
        it { expect(result.success?).to be_falsey }
        it { expect(result.error_message.present?).to be_truthy }
        it { expect(result.hosts.first).to be_nil }
      end
    end
  end

end
