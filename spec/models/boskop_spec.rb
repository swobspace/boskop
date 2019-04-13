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
        allow(Boskop::CONFIG).to receive(:[]).with('nessus_ca_file').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('responsibility_role').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('always_cc').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('graylog_host').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('uuid_blacklist').and_return(nil)
        allow(Boskop::CONFIG).to receive(:[]).with('serial_blacklist').and_return(nil)
      end
      it { expect(Boskop.proxy).to be_nil}
      it { expect(Boskop.host).to eq("localhost")}
      it { expect(Boskop.script_name).to eq("/")}
      it { expect(Boskop.default_recipient).to eq("")}
      it { expect(Boskop.mail_from).to eq("boskop@localhost.local")}
      it { expect(Boskop.nessus_url).to eq("https://localhost:8834")}
      it { expect(Boskop.nessus_ca_file).to be_nil }
      it { expect(Boskop.responsibility_role).
           to contain_exactly("Vulnerabilities") }
      it { expect(Boskop.always_cc).to eq([]) }
      it { expect(Boskop.graylog_host).to eq(nil) }
      it { expect(Boskop.uuid_blacklist).to eq([]) }
      it { expect(Boskop.serial_blacklist).to eq([]) }
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
        allow(Boskop::CONFIG).to receive(:[]).with('nessus_ca_file').
          and_return('/anypath/anyfile')
        allow(Boskop::CONFIG).to receive(:[]).with('responsibility_role').
          and_return(['HOSTMAN'])
        allow(Boskop::CONFIG).to receive(:[]).with('always_cc').
          and_return('hostman@example.org')
        allow(Boskop::CONFIG).to receive(:[]).with('graylog_host').
          and_return('192.0.2.100')
        allow(Boskop::CONFIG).to receive(:[]).with('uuid_blacklist').
          and_return('to be filled by O.E.M.')
        allow(Boskop::CONFIG).to receive(:[]).with('serial_blacklist').
          and_return('O.E.M.')
      end
      it { expect(Boskop.proxy).to eq('http://192.2.0.1:8080') }
      it { expect(Boskop.host).to eq('www.example.com') }
      it { expect(Boskop.script_name).to eq('myapp') }
      it { expect(Boskop.default_recipient).to eq('tester@example.org') }
      it { expect(Boskop.mail_from).to eq('sender@example.org') }
      it { expect(Boskop.nessus_url).to eq('https://nessus.example.org:8834') }
      it { expect(Boskop.nessus_ca_file).to eq('/anypath/anyfile') }
      it { expect(Boskop.responsibility_role).to contain_exactly("HOSTMAN") }
      it { expect(Boskop.always_cc).to contain_exactly("hostman@example.org") }
      it { expect(Boskop.graylog_host).to eq("192.0.2.100") }
      it { expect(Boskop.uuid_blacklist).to contain_exactly("to be filled by O.E.M.") }
      it { expect(Boskop.serial_blacklist).to contain_exactly("O.E.M.") }
    end
  end
  describe "::ldap_options" do
    context" with empty Settings" do
      before(:each) do
        allow(Boskop::CONFIG).to receive(:[]).with('ldap_options').and_return(nil)
      end
      it { expect(Boskop.ldap_options).to be_nil}
    end

    context" with existing Settings" do
      let(:ldap_options) {{
        "host"=>"192.0.2.71",
        "port"=>3268,
        "base"=>"dc=example,dc=com",
        "auth"=>{
           "method"=>:simple,
           "username"=>"myldapuser",
           "password"=>"myldappasswd"
        }
      }}
      let(:ldap_options_sym) {{
        host: "192.0.2.71",
        port: 3268,
        base: "dc=example,dc=com",
        auth: {
           method: :simple,
           username: "myldapuser",
           password: "myldappasswd"
        }
      }}
      before(:each) do
        allow(Boskop::CONFIG).to receive(:[]).with('ldap_options').
          and_return(ldap_options)
      end
      it { expect(Boskop.ldap_options).to eq(ldap_options_sym) }
    end
  end
end
