require "rails_helper"

RSpec.describe VulnerabilitiesMailer, type: :mailer do
  describe "VulnerabilitiesMailer default from" do
    it "uses Boskop.mail_from" do
      expect(VulnerabilitiesMailer.default[:from]).to eq(Boskop.mail_from)
    end
  end

  describe "#send_csv" do
    let(:loc1) { FactoryBot.create(:location, lid: 'BER') }
    let(:os)   { FactoryBot.create(:operating_system, name: 'ZementOS' )}

    let(:host1) { FactoryBot.create(:host, name: "Host1", operating_system: os, location: loc1)}
    let(:host2) { FactoryBot.create(:host, name: "Host2", operating_system: os, location: loc1)}
    let(:h)  { FactoryBot.create(:vulnerability_detail, name: "Oops", threat: 'High', severity: 9.3)}
    let(:h2) { FactoryBot.create(:vulnerability_detail, name: "Puuh", threat: 'High', severity: 9.0)}

    let!(:v1h) { FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: h)}
    let!(:v1h2){ FactoryBot.create(:vulnerability, host: host1, vulnerability_detail: h2)}
    let!(:v2h) { FactoryBot.create(:vulnerability, host: host2, vulnerability_detail: h)}
    let(:vulnerabilities) { Vulnerability.all }

    let(:send_options) {{
      lid: "BER", 
      mail_to: "hostman@example.org", 
      mail_cc: "justforinfo@example.org",
      vulnerabilities: vulnerabilities
    }}
    [:mail_to, :vulnerabilities].each do |option|
      context "with missing option #{option} " do
        it "raise an argument error" do
          send_options.delete(option)
            expect {
            VulnerabilitiesMailer.send_csv(send_options).deliver_now
          }.to raise_error(KeyError)
        end
      end
    end

    context "with real data" do
      let(:mail) { VulnerabilitiesMailer.send_csv(send_options) }
      before(:each) do
        expect(Boskop).to receive(:always_cc).and_return(["always_cc@example.org"])
      end

      it { expect(mail.to).to eq(["hostman@example.org"]) }
      it { expect(mail.cc).to eq(["justforinfo@example.org", "always_cc@example.org"]) }
      it { expect(mail.from).to eq([Boskop.mail_from]) }
      it { expect(mail.subject).to eq(I18n.t('vulnerabilities_mailer.send_csv.subject', lid: "BER")) }
      it { expect(mail.attachments.count).to eq(1) }
   
      context "first attachment" do
	let(:attachment) { mail.attachments.first }

	it "is valid csv" do
	  expect(attachment.content_type).to eq("text/csv")
	  expect(attachment.filename).to eq("vulnerabilities-BER-#{Date.today}.csv")
	  expect {
	    CSV.parse(attachment.body.decoded, {col_sep: "\t", encoding: 'utf-8'})
	  }.not_to raise_error
	end

	it "contains some data" do
	  csv = CSV.parse(attachment.body.decoded, {col_sep: "\t", encoding: 'utf-8'})
	  expect(csv.shift).to contain_exactly(
		  I18n.t('attributes.lid'),
		  I18n.t('attributes.host'),
		  I18n.t('attributes.ip'),
		  I18n.t('attributes.host_category'),
		  I18n.t('attributes.operating_system'),
		  I18n.t('attributes.vulnerability_detail'),
		  I18n.t('attributes.threat'),
		  I18n.t('attributes.severity'),
		  I18n.t('attributes.lastseen'),
		  I18n.t('attributes.created_at'),
		  I18n.t('attributes.plugin_output'),
		)
           expect(csv.count).to eq(3)
	end
      end
    end
  end
end
