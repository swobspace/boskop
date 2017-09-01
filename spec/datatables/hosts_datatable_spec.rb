require 'rails_helper'

RSpec.describe HostsDatatable, type: :model do
  let!(:create_hosts)        { FactoryGirl.create_list(:host, 3) }
  let(:view_context) { double("ActionView::Base") }
  let(:datatable)    { HostsDatatable.new(hosts, view_context) }
  before(:each) do
    allow(view_context).to receive(:params).and_return(myparams)
    allow(view_context).to receive_messages(
      edit_host_path: "",
      host_path: "",
      show_link: "",
      edit_link: "",
      delete_link: "",
      link_to: ""
    )
  end

  describe "without search params" do
    let(:hosts) { Host.left_outer_joins(:location, :host_category) }
    let(:myparams) {
     {order: {"0"=>{column: "0", dir: "desc"}},
     start: "0",
     length: "10",
     search: {value: "", regex: "false"}}
    }
    subject { datatable.to_json }
    # it { puts view_context.params[:order]['0'][:column].inspect }
    it { expect(datatable).to be_a_kind_of HostsDatatable }
    it { expect(parse_json(subject, "recordsTotal")).to eq(3) }
    it { expect(parse_json(subject, "recordsFiltered")).to eq(3) }
    it { expect(parse_json(subject, "data/0")).to include(Host.first.ip.to_s) }
  end 

end
