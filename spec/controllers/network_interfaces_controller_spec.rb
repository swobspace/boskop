require 'rails_helper'

RSpec.describe NetworkInterfacesController, type: :controller do
  login_admin

  let!(:host) { FactoryBot.create(:host) }

  let(:valid_attributes) {
    FactoryBot.attributes_for(:network_interface, host_id: host.id)
  }

  let(:invalid_attributes) {{
    lastseen: nil
  }}

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      NetworkInterface.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      network_interface = NetworkInterface.create! valid_attributes
      expect(network_interface).to be_valid
      get :show, params: {id: network_interface.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      expect{
        get :new, params: {}, session: valid_session
      }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      network_interface = NetworkInterface.create! valid_attributes
      get :edit, params: {id: network_interface.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new NetworkInterface" do
        expect {
          post :create, params: {network_interface: valid_attributes}, session: valid_session
        }.to raise_error(ActionController::UrlGenerationError)

      end

      it "redirects to the created network_interface" do
        expect{
          post :create, params: {network_interface: valid_attributes}, session: valid_session
        }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        expect{
          post :create, params: {network_interface: invalid_attributes}, session: valid_session
        }.to raise_error(ActionController::UrlGenerationError)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{
        mac: '00:11:22:33:EE:FF',
        if_description: "brabbelfasel"
      }}

      it "updates the requested network_interface" do
        network_interface = NetworkInterface.create! valid_attributes
        put :update, params: {id: network_interface.to_param, network_interface: new_attributes}, session: valid_session
        network_interface.reload
        expect(network_interface.mac).to eq('00112233EEFF')
        expect(network_interface.if_description).to eq('brabbelfasel')
      end

      it "redirects to the network_interface" do
        network_interface = NetworkInterface.create! valid_attributes
        put :update, params: {id: network_interface.to_param, network_interface: valid_attributes}, session: valid_session
        expect(response).to redirect_to(network_interface)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        network_interface = NetworkInterface.create! valid_attributes
        put :update, params: {id: network_interface.to_param, network_interface: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested network_interface" do
      network_interface = NetworkInterface.create! valid_attributes
      expect {
        delete :destroy, params: {id: network_interface.to_param}, session: valid_session
      }.to change(NetworkInterface, :count).by(-1)
    end

    it "redirects to the network_interfaces list" do
      network_interface = NetworkInterface.create! valid_attributes
      delete :destroy, params: {id: network_interface.to_param}, session: valid_session
      expect(response).to redirect_to(network_interfaces_url)
    end
  end

end
