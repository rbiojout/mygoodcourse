require "rails_helper"

RSpec.describe PostsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fr/posts").to route_to("posts#index", locale: 'fr')
    end

    it "routes to #new" do
      expect(:get => "/fr/posts/new").to route_to("posts#new", locale: 'fr')
    end

    it "routes to #show" do
      expect(:get => "/fr/posts/1").to route_to("posts#show", :id => "1", locale: 'fr')
    end

    it "routes to #edit" do
      expect(:get => "/fr/posts/1/edit").to route_to("posts#edit", :id => "1", locale: 'fr')
    end

    it "routes to #create" do
      expect(:post => "/fr/posts").to route_to("posts#create", locale: 'fr')
    end

    it "routes to #update via PUT" do
      expect(:put => "/fr/posts/1").to route_to("posts#update", :id => "1", locale: 'fr')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fr/posts/1").to route_to("posts#update", :id => "1", locale: 'fr')
    end

    it "routes to #destroy" do
      expect(:delete => "/fr/posts/1").to route_to("posts#destroy", :id => "1", locale: 'fr')
    end

  end
end
