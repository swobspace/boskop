require 'rails_helper'

RSpec.describe SendVulnerabilitiesMailJob, type: :job do
  let!(:loc1) { FactoryBot.create(:location, lid: 'PXC')}
  let!(:host1) { FactoryBot.create(:host, location: loc1)}
  let(:c) { FactoryBot.create(:vulnerability_detail, threat: 'Critical', severity: 10.0)}
  let(:h)  { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.3)}
  let(:m)  { FactoryBot.create(:vulnerability_detail, threat: 'Medium', severity: 5.0)}
  let!(:v1c) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: c)}
  let!(:v1h) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: h)}
  let!(:v1m) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: m)}

  let(:contact) { FactoryBot.create(:contact, mail: "vulns@example.net") }
  let!(:responsible) { FactoryBot.create(:responsibility, 
    contact: contact,
    role: 'Vulnerabilities',
    responsibility_for: loc1
  )}
  let(:send_csv) { double(VulnerabilitiesMailer.send_csv(vulnerabilities: Vulnerability.limit(1), mail_to: "nonsense@example.com")) }

  describe "#perform" do
    before(:each) do
      expect(send_csv).to receive(:deliver_now)
    end

    context "with at: Date.today" do
      it "calls VulnerabiltiesMail.send_csv with" do
        expect(VulnerabilitiesMailer).to receive(:send_csv).with(
          vulnerabilities: VulnerabilityQuery.new(loc1.vulnerabilities, since: Date.yesterday).all,
          mail_to: ['vulns@example.net'],
          lid: 'PXC'
        ).and_return(send_csv)
        SendVulnerabilitiesMailJob.perform_now(at: Date.today)
      end
    end

    context "with location: PXC" do
      it "calls VulnerabiltiesMail.send_csv with" do
        expect(VulnerabilitiesMailer).to receive(:send_csv).with(
          vulnerabilities:  VulnerabilityQuery.new(loc1.vulnerabilities, since: Date.yesterday).all,
          mail_to: ['vulns@example.net'],
          lid: 'PXC'
        ).and_return(send_csv)
        SendVulnerabilitiesMailJob.perform_now(lid: 'PXC')
      end
    end
    context "with no args" do
      it "calls VulnerabiltiesMail.send_csv with" do
        expect(VulnerabilitiesMailer).to receive(:send_csv).with(
          vulnerabilities: VulnerabilityQuery.new(loc1.vulnerabilities, since: Date.today).all,
          mail_to: ['vulns@example.net'],
          lid: 'PXC'
        ).and_return(send_csv)
        SendVulnerabilitiesMailJob.perform_now()
      end
    end
  end

end
