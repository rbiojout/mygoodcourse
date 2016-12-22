require "rails_helper"

RSpec.describe TopicsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fr/topics").to route_to("topics#index", locale: 'fr')
    end

    it "routes to #new" do
      expect(:get => "/fr/topics/new").to route_to("topics#new", locale: 'fr')
    end

    it "routes to #show" do
      expect(:get => "/fr/topics/1").to route_to("topics#show", :id => "1", locale: 'fr')
    end

    it "routes to #edit" do
      expect(:get => "/fr/topics/1/edit").to route_to("topics#edit", :id => "1", locale: 'fr')
    end

    it "routes to #create" do
      expect(:post => "/fr/topics").to route_to("topics#create", locale: 'fr')
    end

    it "routes to #update via PUT" do
      expect(:put => "/fr/topics/1").to route_to("topics#update", :id => "1", locale: 'fr')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fr/topics/1").to route_to("topics#update", :id => "1", locale: 'fr')
    end

    it "routes to #destroy" do
      expect(:delete => "/fr/topics/1").to route_to("topics#destroy", :id => "1", locale: 'fr')
    end

    it "routes to #sort" do
      expect(:post => "/fr/topics/sort").to route_to("topics#sort", locale: 'fr')
    end
  end
end
