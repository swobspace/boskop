require 'rails_helper'

RSpec.describe ApplicationDatatableConcerns, type: :model do
  include ApplicationDatatableConcerns
  describe "with HostsDatatables" do
    let(:hosts_datatable_params) {{
      "draw"=>"71",
      "columns"=>
      {"0"=>
	{"data"=>"0",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"mypc", "regex"=>"false"}},
       "1"=>
	{"data"=>"1",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"", "regex"=>"false"}},
       "2"=>
	{"data"=>"2",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"198.51.100", "regex"=>"false"}},
       "3"=>
	{"data"=>"3",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"windows_7", "regex"=>"false"}},
       "4"=>
	{"data"=>"4",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"Windows 5.1", "regex"=>"false"}},
       "5"=>
	{"data"=>"5",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"my.example.net", "regex"=>"false"}},
       "6"=>
	{"data"=>"6",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"example.net", "regex"=>"false"}},
       "7"=>
	{"data"=>"7",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"MY", "regex"=>"false"}},
       "8"=>
	{"data"=>"8",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>Date.today.to_s, "regex"=>"false"}},
       "9"=>
	{"data"=>"9",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"12:34:56:78:90:0a", "regex"=>"false"}},
       "10"=>
	{"data"=>"10",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"", "regex"=>"false"}},
       "11"=>
	{"data"=>"11",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"", "regex"=>"false"}},
       "12"=>
	{"data"=>"12",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"", "regex"=>"false"}},
       "13"=>
	{"data"=>"13",
	 "name"=>"",
	 "searchable"=>"true",
	 "orderable"=>"true",
	 "search"=>{"value"=>"", "regex"=>"false"}}},
     "order"=>{"0"=>{"column"=>"0", "dir"=>"desc"}},
     "start"=>"0",
     "length"=>"10",
     "search"=>{"value"=>"test", "regex"=>"false"}
    }}
    let(:host_columns) {
      %w(name description ip cpe raw_os fqdn domain_dns workgroup lastseen mac vendor host_category lid)
    }

    describe "#search_params(params, columns)" do
      let(:searchparms) {{
        "name"=>"mypc", "ip"=>"198.51.100", "cpe"=>"windows_7", "raw_os"=>"Windows 5.1", 
        "fqdn"=>"my.example.net", "domain_dns"=>"example.net", "workgroup"=>"MY", 
        "lastseen"=>"2017-09-02", "mac"=>"12:34:56:78:90:0a", "search"=>"test"
      }}
      subject { search_params(hosts_datatable_params, host_columns) }
      it { expect(subject).to be_a_kind_of Hash }
      it { expect(subject).to eq(searchparms) }
      it { expect(subject).not_to include("vendor", "host_category", 
                                           "lid", "description")}
    end

    describe "#search_params({}, columns)" do
      subject { search_params({}, host_columns) }
      it "results in empty hash" do
        expect(subject).to eq({})
      end
    end

  end
end
