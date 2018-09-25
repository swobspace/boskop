require 'rails_helper'

RSpec.describe UpdateVulnRiskJob, type: :job do
  let!(:host1) { FactoryBot.create(:host)}
  let!(:host2) { FactoryBot.create(:host)}
  let!(:host3) { FactoryBot.create(:host)}
  let!(:host4) { FactoryBot.create(:host, lastseen: 5.weeks.before(Date.today))}
  let(:h)  { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.3)}
  let(:h2) { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.0)}
  let(:m) { FactoryBot.create(:vulnerability_detail, threat: 'Medium', severity: 5.0)}
  let(:l) { FactoryBot.create(:vulnerability_detail, threat: 'Low', severity: 2.1)}
  let(:c) { FactoryBot.create(:vulnerability_detail, threat: 'Critical', severity: 10.0)}   

  let!(:v1h) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: h)}
  let!(:v1h2) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: h)}
  let!(:v1m) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: m)}
  let!(:v1c) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: c)}

  let!(:v2h) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: h)}
  let!(:v2h2) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: h)}
  let!(:v2m) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: m)}
  let!(:v2l) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: l)}

  let!(:v3m) { FactoryBot.create(:vulnerability, host: host3, vulnerability_detail: m)}
  let!(:v3l) { FactoryBot.create(:vulnerability, host: host3, vulnerability_detail: l)}

  let!(:v4l) { FactoryBot.create(:vulnerability, host: host4, vulnerability_detail: l,
                                 lastseen: 5.weeks.before(Date.today))}

  describe "#perform" do
    it "does not raise an error" do
      expect {
        UpdateVulnRiskJob.perform_now
      }.not_to raise_error
    end

    # just as cross check
    it { expect(host1.vulnerabilities.count).to eq(4) }
    it { expect(host2.vulnerabilities.count).to eq(4) }
    it { expect(host3.vulnerabilities.count).to eq(2) }
    it { expect(host4.vulnerabilities.count).to eq(1) }

    context "with real data" do
      before(:each) do
	UpdateVulnRiskJob.perform_now
      end

      it { host1.reload; expect(host1.vuln_risk).to eq("Critical") }
      it { host2.reload; expect(host2.vuln_risk).to eq("High") }
      it { host3.reload; expect(host3.vuln_risk).to eq("Medium") }
      it { host4.reload; expect(host4.vuln_risk).to eq("") }
    end
  end
end
