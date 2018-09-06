require 'rails_helper'

describe Boskop do
  describe "::proxy" do
    context" with empty Settings" do
      before(:each) do
        allow(Boskop::CONFIG).to receive(:[]).with('proxy').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('host').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('script_name').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('default_recipient').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('mail_from').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('nessus_url').and_return(nil)
      end
      it { expect(Boskop.proxy).to be_nil}
      it { expect(Boskop.host).to eq("localhost")}
      it { expect(Boskop.script_name).to eq("/")}
      it { expect(Boskop.default_recipient).to eq("")}
      it { expect(Boskop.mail_from).to eq("boskop@localhost.local")}
      it { expect(Boskop.nessus_url).to eq("https://localhost:8834")}
    end

    context" with existing Settings" do
      before(:each) do
        allow(Boskop::CONFIG).to receive(:[]).with('proxy').
          and_return('http://192.2.0.1:8080')
        allow(Boskop::CONFIG).to receive(:[]).with('host').
          and_return('www.example.com')
        allow(Boskop::CONFIG).to receive(:[]).with('script_name').
          and_return('myapp')
        allow(Boskop::CONFIG).to receive(:[]).with('default_recipient').
          and_return('tester@example.org')
        allow(Boskop::CONFIG).to receive(:[]).with('mail_from').
          and_return('sender@example.org')
        allow(Boskop::CONFIG).to receive(:[]).with('nessus_url').
          and_return('https://nessus.example.org:8834')
      end
      it { expect(Boskop.proxy).to eq('http://192.2.0.1:8080') }
      it { expect(Boskop.host).to eq('www.example.com') }
      it { expect(Boskop.script_name).to eq('myapp') }
      it { expect(Boskop.default_recipient).to eq('tester@example.org') }
      it { expect(Boskop.mail_from).to eq('sender@example.org') }
      it { expect(Boskop.nessus_url).to eq('https://nessus.example.org:8834') }
    end
  end
end

