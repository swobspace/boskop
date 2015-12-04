require "rails_helper"

RSpec.describe LineStatesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/line_states").to route_to("line_states#index")
    end

    it "routes to #new" do
      expect(:get => "/line_states/new").to route_to("line_states#new")
    end

    it "routes to #show" do
      expect(:get => "/line_states/1").to route_to("line_states#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/line_states/1/edit").to route_to("line_states#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/line_states").to route_to("line_states#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/line_states/1").to route_to("line_states#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/line_states/1").to route_to("line_states#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/line_states/1").to route_to("line_states#destroy", :id => "1")
    end

  end
end
