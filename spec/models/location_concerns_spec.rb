require 'rails_helper'

RSpec.describe LocationConcerns, type: :model do
  let(:loc1)   { FactoryBot.create(:location, lid: 'ABC') }
  let(:loc2)   { FactoryBot.create(:location, lid: 'XYZ') }
  let(:loc3)   { FactoryBot.create(:location, lid: 'BER') }
  let(:os1) { FactoryBot.create(:operating_system, name: "ZementOS") }
  let(:os2) { FactoryBot.create(:operating_system, name: "PlainOS") }
  let(:hc)  { FactoryBot.create(:host_category, name: 'CategoryA') }

  let!(:host1) { FactoryBot.create(:host, location: loc1) }
  let!(:host2) { FactoryBot.create(:host, location: loc2) }
  let!(:host3) { FactoryBot.create(:host, location: loc3) }

  let(:h)  { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.3)}
  let(:h2) { FactoryBot.create(:vulnerability_detail, threat: 'High', severity: 9.0)}
  let(:m) { FactoryBot.create(:vulnerability_detail, threat: 'Medium', severity: 5.0)}
  let(:l) { FactoryBot.create(:vulnerability_detail, threat: 'Low', severity: 2.1)}

  let!(:v1h) { FactoryBot.create(:vulnerability, 
    host: host1, 
    lastseen: Date.today,
    vulnerability_detail: h
  )}
  let!(:v1m) { FactoryBot.create(:vulnerability, 
    host: host1, 
    lastseen: 1.day.before(Date.today),
    vulnerability_detail: m
  )}

  let!(:v2h2) { FactoryBot.create(:vulnerability, 
    host: host2, 
    lastseen: 2.day.before(Date.today),
    vulnerability_detail: h2
  )}
  let!(:v2l) { FactoryBot.create(:vulnerability, 
    host: host2, 
    lastseen: 3.day.before(Date.today),
    vulnerability_detail: l
  )}
  let!(:v3m) { FactoryBot.create(:vulnerability, 
    host: host3, 
    lastseen: 4.day.before(Date.today),
    vulnerability_detail: m
  )}

  describe "::with_new_vulns_since" do
    it { expect(Location.with_new_vulns_since(Date.today)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns_since(Date.yesterday)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns_since(3.days.before(Date.today))).to contain_exactly(loc1, loc2) }
    it { expect(Location.with_new_vulns_since(7.days.before(Date.today))).to contain_exactly(loc1, loc2, loc3) }
  end

  describe "::with_new_vulns(since: ..)" do
    it { expect(Location.with_new_vulns(since: Date.today)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns(since: Date.yesterday)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns(since: 3.days.before(Date.today))).to contain_exactly(loc1, loc2) }
    it { expect(Location.with_new_vulns(since: 7.days.before(Date.today))).to contain_exactly(loc1, loc2, loc3) }
  end

  describe "::with_new_vulns_at" do
    it { expect(Location.with_new_vulns_at(Date.today)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns_at(Date.yesterday)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns_at(2.days.before(Date.today))).to contain_exactly(loc2) }
    it { expect(Location.with_new_vulns_at(4.days.before(Date.today))).to contain_exactly(loc3) }
    it { expect(Location.with_new_vulns_at(5.days.before(Date.today))).to contain_exactly() }
  end

  describe "::with_new_vulns(at: ..)" do
    it { expect(Location.with_new_vulns(at: Date.today)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns(at: Date.yesterday)).to contain_exactly(loc1) }
    it { expect(Location.with_new_vulns(at: 2.days.before(Date.today))).to contain_exactly(loc2) }
    it { expect(Location.with_new_vulns(at: 4.days.before(Date.today))).to contain_exactly(loc3) }
    it { expect(Location.with_new_vulns(at: 5.days.before(Date.today))).to contain_exactly() }
  end

end
