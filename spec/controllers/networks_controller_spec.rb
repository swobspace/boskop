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

RSpec.describe NetworksController, :type => :controller do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # Network. As you add validations to Network, be sure to
  # adjust the attributes here as well.
  let!(:location) { FactoryBot.create(:location) }
  let(:valid_attributes) {
    FactoryBot.attributes_for(:network, location_id: location.id)
  }

  let(:invalid_attributes) {
    { netzwerk: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NetworksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all networks as @networks" do
      network = Network.create! valid_attributes
      get :index, params: {}
      expect(assigns(:networks)).to eq([network])
    end
  end

  describe "GET show" do
    it "assigns the requested network as @network" do
      network = Network.create! valid_attributes
      get :show, params: {:id => network.to_param}
      expect(assigns(:network)).to eq(network)
    end
  end

  describe "GET search" do
    it "displays the search form" do
      get :search, params: {}
      expect(response).to render_template('search')
    end
  end

  describe "GET usage_form" do
    it "displays the usage_form form" do
      get :usage_form, params: {}
      expect(response).to render_template('usage_form')
    end
  end

  describe "GET new" do
    it "assigns a new network as @network" do
      get :new, params: {}
      expect(assigns(:network)).to be_a_new(Network)
    end
    it "assigns a netzwerk to new network @network" do
      get :new, params: {netzwerk: "10.20.30.0/24"}
      expect(assigns(:network).netzwerk.to_cidr_s).to eq("10.20.30.0/24")
    end
    it "assigns a description to new network @network" do
      get :new, params: {description: "brabbelfasel"}
      expect(assigns(:network).description).to eq("brabbelfasel")
    end
    it "assigns location_id to new network @network" do
      get :new, params: {location_id: "47110815"}
      expect(assigns(:network).location_id).to eq(47110815)
    end
  end

  describe "GET edit" do
    it "assigns the requested network as @network" do
      network = Network.create! valid_attributes
      get :edit, params: {:id => network.to_param}
      expect(assigns(:network)).to eq(network)
    end
  end

  describe "POST search" do
    describe "with valid params" do
      let(:search_attributes) {{ cidr: '192.168.0.0/16', is_subnet: 1, is_superset: 1 }}
      it "shows matching networks" do
        network = FactoryBot.create(:network, netzwerk: '192.168.1.0/24')
        post :search, params: search_attributes
        expect(assigns(:networks)).to include(network)
      end
    end
  end

  describe "POST usage" do
    describe "with valid params" do
      let(:usage_attributes) {{ cidr: '192.168.0.0/16', mask: '24' }}
      it "shows network usage table" do
        network = FactoryBot.create(:network, netzwerk: '192.168.1.0/24')
        post :usage, params: usage_attributes
        expect(assigns(:networks)).to include(network)
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Network" do
        expect {
          post :create, params: {:network => valid_attributes}
        }.to change(Network, :count).by(1)
      end

      it "assigns a newly created network as @network" do
        post :create, params: {:network => valid_attributes}
        expect(assigns(:network)).to be_a(Network)
        expect(assigns(:network)).to be_persisted
      end

      it "redirects to the created network" do
        post :create, params: {:network => valid_attributes}
        expect(response).to redirect_to(Network.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved network as @network" do
        post :create, params: {:network => invalid_attributes}
        expect(assigns(:network)).to be_a_new(Network)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:network => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        { description: "brabbelfasel", netzwerk: '192.51.81.32/27'}
      }

      it "updates the requested network" do
        network = Network.create! valid_attributes
        put :update, params: {:id => network.to_param, :network => new_attributes}
        network.reload
        expect(network.description).to eq("brabbelfasel")
        expect(network.to_str).to eq("192.51.81.32/27")
      end

      it "assigns the requested network as @network" do
        network = Network.create! valid_attributes
        put :update, params: {:id => network.to_param, :network => valid_attributes}
        expect(assigns(:network)).to eq(network)
      end

      it "redirects to the network" do
        network = Network.create! valid_attributes
        put :update, params: {:id => network.to_param, :network => valid_attributes}
        expect(response).to redirect_to(network)
      end
    end

    describe "with invalid params" do
      it "assigns the network as @network" do
        network = Network.create! valid_attributes
        put :update, params: {:id => network.to_param, :network => invalid_attributes}
        expect(assigns(:network)).to eq(network)
      end

      it "re-renders the 'edit' template" do
        network = Network.create! valid_attributes
        put :update, params: {:id => network.to_param, :network => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested network" do
      network = Network.create! valid_attributes
      expect {
        delete :destroy, params: {:id => network.to_param}
      }.to change(Network, :count).by(-1)
    end

    it "redirects to the networks list" do
      network = Network.create! valid_attributes
      delete :destroy, params: {:id => network.to_param}
      expect(response).to redirect_to(networks_url)
    end
  end

end
