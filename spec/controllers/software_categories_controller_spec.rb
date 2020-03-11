require 'rails_helper'

RSpec.describe SoftwareCategoriesController, type: :controller do
  login_admin

  let(:swgrp) { FactoryBot.create(:software_group) }
  let(:valid_attributes) {
    FactoryBot.attributes_for(:software_category)
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      SoftwareCategory.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      software_category = SoftwareCategory.create! valid_attributes
      get :show, params: {id: software_category.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      software_category = SoftwareCategory.create! valid_attributes
      get :edit, params: {id: software_category.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new SoftwareCategory" do
        expect {
          post :create, params: {software_category: valid_attributes}, session: valid_session
        }.to change(SoftwareCategory, :count).by(1)
      end

      it "redirects to the created software_category" do
        post :create, params: {software_category: valid_attributes}, session: valid_session
        expect(response).to redirect_to(SoftwareCategory.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {software_category: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{
        description: "A new description",  
        main_business_process: "Hammeringsomethingfine",
        software_group_id: swgrp.id
      }}

      it "updates the requested software_category" do
        software_category = SoftwareCategory.create! valid_attributes
        put :update, params: {id: software_category.to_param, software_category: new_attributes}, session: valid_session
        software_category.reload
        expect(software_category.description).to eq("A new description")
        expect(software_category.main_business_process).to eq("Hammeringsomethingfine")
      end

      it "redirects to the software_category" do
        software_category = SoftwareCategory.create! valid_attributes
        put :update, params: {id: software_category.to_param, software_category: valid_attributes}, session: valid_session
        expect(response).to redirect_to(software_category)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_category = SoftwareCategory.create! valid_attributes
        put :update, params: {id: software_category.to_param, software_category: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested software_category" do
      software_category = SoftwareCategory.create! valid_attributes
      expect {
        delete :destroy, params: {id: software_category.to_param}, session: valid_session
      }.to change(SoftwareCategory, :count).by(-1)
    end

    it "redirects to the software_categories list" do
      software_category = SoftwareCategory.create! valid_attributes
      delete :destroy, params: {id: software_category.to_param}, session: valid_session
      expect(response).to redirect_to(software_categories_url)
    end
  end

end
