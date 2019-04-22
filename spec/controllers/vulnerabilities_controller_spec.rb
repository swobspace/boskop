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

RSpec.describe VulnerabilitiesController, type: :controller do
  login_admin
 
  let(:openvas_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'openvas-wobnet-anon.xml') }
  let(:nessus_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'netxp-nessus.xml') }
  let(:vulndetail) { FactoryBot.create(:vulnerability_detail, name: "End-of-Life") }
  let(:host)       { FactoryBot.create(:host, name: 'vxserver') }
  let!(:iface)      { FactoryBot.create(:network_interface, ip: '192.81.51.93', host: host) }

  let(:valid_attributes) {{
    host_id: host.id, vulnerability_detail_id: vulndetail.id, lastseen: Date.today
  }}

  let(:invalid_attributes) {
    { host_id: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VulnerabilitiesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      vulnerability = Vulnerability.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #search" do
    it "returns a success response" do
      vulnerability = Vulnerability.create! valid_attributes
      get :search, params: {ip: '192.81.51'}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      vulnerability = Vulnerability.create! valid_attributes
      get :show, params: {id: vulnerability.to_param}, session: valid_session
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
      vulnerability = Vulnerability.create! valid_attributes
      get :edit, params: {id: vulnerability.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #import" do
    context "with openvas xml" do
      let(:import_form_attributes) {{ type: 'openvas', file: openvas_file }}
      it "imports vulnerabilities from openvas xml" do
        expect {
          post :import, params: import_form_attributes, session: valid_session
        }.to change(Vulnerability, :count).by(2)
      end

      it "redirects to vulnerabilities_path" do
        post :import, params: import_form_attributes, session: valid_session
        expect(response).to redirect_to(vulnerabilities_path)
      end
    end
  end

  describe "POST #import" do
    context "with nessus xml" do
      let(:import_form_attributes) {{ type: 'nessus', file: nessus_file }}
      it "imports vulnerabilities from nessus xml" do
        expect {
          post :import, params: import_form_attributes, session: valid_session
        }.to change(Vulnerability, :count).by(5)
      end

      it "redirects to vulnerabilities_path" do
        post :import, params: import_form_attributes, session: valid_session
        expect(response).to redirect_to(vulnerabilities_path)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Vulnerability" do
        expect {
          post :create, params: {vulnerability: valid_attributes}, session: valid_session
        }.to change(Vulnerability, :count).by(1)
      end

      it "redirects to the created vulnerability" do
        post :create, params: {vulnerability: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Vulnerability.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {vulnerability: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{
        lastseen: 1.day.after(Date.today)
      }}

      it "updates the requested vulnerability" do
        vulnerability = Vulnerability.create! valid_attributes
        put :update, params: {id: vulnerability.to_param, vulnerability: new_attributes}, session: valid_session
        vulnerability.reload
        expect(vulnerability.lastseen).to eq(1.day.after(Date.today))
      end

      it "redirects to the vulnerability" do
        vulnerability = Vulnerability.create! valid_attributes
        put :update, params: {id: vulnerability.to_param, vulnerability: valid_attributes}, session: valid_session
        expect(response).to redirect_to(vulnerability)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        vulnerability = Vulnerability.create! valid_attributes
        put :update, params: {id: vulnerability.to_param, vulnerability: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested vulnerability" do
      vulnerability = Vulnerability.create! valid_attributes
      expect {
        delete :destroy, params: {id: vulnerability.to_param}, session: valid_session
      }.to change(Vulnerability, :count).by(-1)
    end

    it "redirects to the vulnerabilities list" do
      vulnerability = Vulnerability.create! valid_attributes
      delete :destroy, params: {id: vulnerability.to_param}, session: valid_session
      expect(response).to redirect_to(vulnerabilities_url)
    end
  end

end
