require "rails_helper"

RSpec.describe ProductsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fr/products").to route_to("products#index", locale: 'fr')
    end

    it "routes to #new" do
      expect(:get => "/fr/products/new").to route_to("products#new", locale: 'fr')
    end

    it "routes to #show" do
      expect(:get => "/fr/products/1").to route_to("products#show", :id => "1", locale: 'fr')
    end

    it "routes to #edit" do
      expect(:get => "/fr/products/1/edit").to route_to("products#edit", :id => "1", locale: 'fr')
    end

    it "routes to #create" do
      expect(:post => "/fr/products").to route_to("products#create", locale: 'fr')
    end

    it "routes to #update via PUT" do
      expect(:put => "/fr/products/1").to route_to("products#update", :id => "1", locale: 'fr')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fr/products/1").to route_to("products#update", :id => "1", locale: 'fr')
    end

    it "routes to #destroy" do
      expect(:delete => "/fr/products/1").to route_to("products#destroy", :id => "1", locale: 'fr')
    end

    it 'routes to #myproducts' do
      expect(:get => '/fr/products/myproducts').to route_to('products#myproducts', locale: 'fr')
    end

    it 'routes to #catalog' do
      expect(:get => '/fr/products/catalog').to route_to('products#catalog', locale: 'fr')
    end

  end
end
