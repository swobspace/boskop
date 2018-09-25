require "rails_helper"

RSpec.describe HostsHelper, :type => :helper do

  describe "#risk_button" do
    context "with risk: Critical" do
      let(:risk) { 'Critical' }
      subject { Capybara.string(helper.risk_button(risk)) }
      it { expect(subject.find("button").text).to match(risk) }
      it { expect(subject.find("button")['class']).to match("btn btn-danger") }
    end
    context "with risk: High" do
      let(:risk) { 'High' }
      subject { Capybara.string(helper.risk_button(risk)) }
      it { expect(subject.find("button").text).to match(risk) }
      it { expect(subject.find("button")['class']).to match("btn btn-danger") }
    end
    context "with risk: Medium" do
      let(:risk) { 'Medium' }
      subject { Capybara.string(helper.risk_button(risk)) }
      it { expect(subject.find("button").text).to match(risk) }
      it { expect(subject.find("button")['class']).to match("btn btn-warning") }
    end
    context "with risk: Low" do
      let(:risk) { 'Low' }
      subject { Capybara.string(helper.risk_button(risk)) }
      it { expect(subject.find("button").text).to match('Low') }
      it { expect(subject.find("button")['class']).to match("btn btn-light") }
    end
    context "with risk: None" do
      let(:risk) { 'None' }
      subject { Capybara.string(helper.risk_button(risk)) }
      it { expect(subject.find("button").text).to match('Low') }
      it { expect(subject.find("button")['class']).to match("btn btn-light") }
    end
    context "with risk: empty" do
      let(:risk) { '' }
      subject { Capybara.string(helper.risk_button(risk)) }
      it { expect(subject.find("button").text).to match('Low') }
      it { expect(subject.find("button")['class']).to match("btn btn-light") }
    end
  end

end
