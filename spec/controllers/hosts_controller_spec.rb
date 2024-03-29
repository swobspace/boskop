require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe HostsController, type: :controller do
  login_admin

  let(:csv_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'wob42.csv') }

  let(:valid_attributes) {
    FactoryBot.attributes_for(:host)
  }
  let(:invalid_attributes) {
    { lastseen: nil }
  }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      host = Host.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #search" do

    context "with default format" do
      it "returns a success response" do
	host = Host.create! valid_attributes
	get :search, params: {serial: 'XXX73V', eol: 1, current: 1, vuln_risk: 1}, session: valid_session
	expect(response).to be_successful
      end
    end

    context "with format :csv" do
      it "returns a success response" do
        host = Host.create! valid_attributes
        get :search, params: {eol: 1, current: 1, vuln_risk: 1, format: :csv}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      host = Host.create! valid_attributes
      get :show, params: {id: host.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new_import" do
    it "returns a success response" do
      get :new_import, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end


  describe "GET #edit" do
    it "returns a success response" do
      host = Host.create! valid_attributes
      get :edit, params: {id: host.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #import" do
    context "with valid params" do
      let(:import_form_attributes) {{ type: 'csv', file: csv_file }}
      it "imports hosts from csv" do
        expect {
          post :import, params: import_form_attributes, session: valid_session
        }.to change(Host, :count).by(1)
      end

      it "redirects to hosts_path" do
        post :import, params: import_form_attributes, session: valid_session
        expect(response).to redirect_to(hosts_path)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Host" do
        expect {
          post :create, params: {host: valid_attributes}, session: valid_session
        }.to change(Host, :count).by(1)
      end

      it "redirects to the created host" do
        post :create, params: {host: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Host.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {host: invalid_attributes}, session: valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{ 
        name: "othertux", fqdn: 'othertux.example.net', 
        vendor: "Tuxolino",
        domain_dns: 'example.net', 
        workgroup: 'WORKGROUP2',
        serial: 'BRAXX937',
        uuid: 'FA289A70-4803-11E9-8CCD-111222333444',
        product: "Optimus Primus",
        warranty_sla: "3 years bring in",
        warranty_start: "2019-03-01",
        warranty_end: "2022-02-28",
      }}

      it "updates the requested host" do
        host = Host.create! valid_attributes
        put :update, params: {id: host.to_param, host: new_attributes}, session: valid_session
        host.reload
        expect(host.name).to eq("othertux")
        expect(host.fqdn).to eq("othertux.example.net")
        expect(host.vendor).to eq("Tuxolino")
        expect(host.domain_dns).to eq("example.net")
        expect(host.workgroup).to eq("WORKGROUP2")
        expect(host.serial).to eq("BRAXX937")
        expect(host.uuid).to eq('FA289A70-4803-11E9-8CCD-111222333444')
        expect(host.product).to eq("Optimus Primus")
        expect(host.warranty_sla).to eq("3 years bring in")
        expect(host.warranty_start.to_s).to eq("2019-03-01")
        expect(host.warranty_end.to_s).to eq("2022-02-28")
      end

      it "redirects to the host" do
        host = Host.create! valid_attributes
        put :update, params: {id: host.to_param, host: valid_attributes}, session: valid_session
        expect(response).to redirect_to(host)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        host = Host.create! valid_attributes
        put :update, params: {id: host.to_param, host: invalid_attributes}, session: valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested host" do
      host = Host.create! valid_attributes
      expect {
        delete :destroy, params: {id: host.to_param}, session: valid_session
      }.to change(Host, :count).by(-1)
    end

    it "redirects to the hosts list" do
      host = Host.create! valid_attributes
      delete :destroy, params: {id: host.to_param}, session: valid_session
      expect(response).to redirect_to(hosts_url)
    end
  end

end
