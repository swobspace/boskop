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

RSpec.describe AccessTypesController, type: :controller do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # AccessType. As you add validations to AccessType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryGirl.attributes_for(:access_type)
  }

  let(:invalid_attributes) {
    { name: nil}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AccessTypesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all access_types as @access_types" do
      access_type = AccessType.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:access_types)).to eq([access_type])
    end
  end

  describe "GET #show" do
    it "assigns the requested access_type as @access_type" do
      access_type = AccessType.create! valid_attributes
      get :show, {:id => access_type.to_param}, valid_session
      expect(assigns(:access_type)).to eq(access_type)
    end
  end

  describe "GET #new" do
    it "assigns a new access_type as @access_type" do
      get :new, {}, valid_session
      expect(assigns(:access_type)).to be_a_new(AccessType)
    end
  end

  describe "GET #edit" do
    it "assigns the requested access_type as @access_type" do
      access_type = AccessType.create! valid_attributes
      get :edit, {:id => access_type.to_param}, valid_session
      expect(assigns(:access_type)).to eq(access_type)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new AccessType" do
        expect {
          post :create, {:access_type => valid_attributes}, valid_session
        }.to change(AccessType, :count).by(1)
      end

      it "assigns a newly created access_type as @access_type" do
        post :create, {:access_type => valid_attributes}, valid_session
        expect(assigns(:access_type)).to be_a(AccessType)
        expect(assigns(:access_type)).to be_persisted
      end

      it "redirects to the created access_type" do
        post :create, {:access_type => valid_attributes}, valid_session
        expect(response).to redirect_to(AccessType.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved access_type as @access_type" do
        post :create, {:access_type => invalid_attributes}, valid_session
        expect(assigns(:access_type)).to be_a_new(AccessType)
      end

      it "re-renders the 'new' template" do
        post :create, {:access_type => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { description: "very long line" }
      }

      it "updates the requested access_type" do
        access_type = AccessType.create! valid_attributes
        put :update, {:id => access_type.to_param, :access_type => new_attributes}, valid_session
        access_type.reload
        expect(access_type.description).to eq("very long line")
      end

      it "assigns the requested access_type as @access_type" do
        access_type = AccessType.create! valid_attributes
        put :update, {:id => access_type.to_param, :access_type => valid_attributes}, valid_session
        expect(assigns(:access_type)).to eq(access_type)
      end

      it "redirects to the access_type" do
        access_type = AccessType.create! valid_attributes
        put :update, {:id => access_type.to_param, :access_type => valid_attributes}, valid_session
        expect(response).to redirect_to(access_type)
      end
    end

    context "with invalid params" do
      it "assigns the access_type as @access_type" do
        access_type = AccessType.create! valid_attributes
        put :update, {:id => access_type.to_param, :access_type => invalid_attributes}, valid_session
        expect(assigns(:access_type)).to eq(access_type)
      end

      it "re-renders the 'edit' template" do
        access_type = AccessType.create! valid_attributes
        put :update, {:id => access_type.to_param, :access_type => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested access_type" do
      access_type = AccessType.create! valid_attributes
      expect {
        delete :destroy, {:id => access_type.to_param}, valid_session
      }.to change(AccessType, :count).by(-1)
    end

    it "redirects to the access_types list" do
      access_type = AccessType.create! valid_attributes
      delete :destroy, {:id => access_type.to_param}, valid_session
      expect(response).to redirect_to(access_types_url)
    end
  end

end
