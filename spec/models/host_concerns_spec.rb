require 'rails_helper'

RSpec.describe HostConcerns, type: :model do
  let(:loc1)   { FactoryBot.create(:location, lid: 'ABC') }
  let(:loc2)   { FactoryBot.create(:location, lid: 'XYZ') }

  let!(:host1) { FactoryBot.create(:host, location: loc1)}
  let!(:host2) { FactoryBot.create(:host, location: loc1)}
  let!(:host3) { FactoryBot.create(:host, location: loc2)}
  let!(:host4) { FactoryBot.create(:host)}
  let!(:host5) { FactoryBot.create(:host, lastseen: 5.weeks.before(Date.today))}
  let!(:host6) { FactoryBot.create(:host, location: loc2)}
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

  let!(:v4l) { FactoryBot.create(:vulnerability, host: host4, vulnerability_detail: l)}

  let!(:v5l) { FactoryBot.create(:vulnerability, host: host4, vulnerability_detail: l,
                                 lastseen: 5.weeks.before(Date.today))}

  let!(:v6m) { FactoryBot.create(:vulnerability, host: host6, vulnerability_detail: m)}

  describe "::vuln_risk_matrix" do
    before(:each) do 
      UpdateVulnRiskJob.perform_now
    end

    it "generates vuln risk matrix" do
      expect(Host.vuln_risk_matrix).to contain_exactly(
        ["Critical", "ABC", 1],
        ["High", "ABC", 1],
        ["Medium", "XYZ", 2],
        ["Low", nil, 1]
      )
    end

  end
end
