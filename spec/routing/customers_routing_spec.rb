require "rails_helper"

RSpec.describe CustomersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fr/customers").to route_to("customers#index", :locale => "fr", "path"=>"fr/customers")
    end


    it "routes to #show" do
      expect(:get => "/fr/customers/1").to route_to("customers#show", :locale => "fr", :id => "1", "path"=>"fr/customers/1")
    end

    it "routes to #edit" do
      expect(:get => "/fr/customers/1/edit").to route_to("customers#edit", :locale => "fr", :id => "1", "path"=>"fr/customers/1/edit")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fr/customers/1").to route_to("customers#update", :locale => "fr", :id => "1", "path"=>"fr/customers/1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fr/customers/1").to route_to("customers#update", :locale => "fr", :id => "1", "path"=>"fr/customers/1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fr/customers/1").to route_to("customers#destroy", :locale => "fr", :id => "1", "path"=>"fr/customers/1")
    end

    it "routes to #circle" do
      expect(:get => "/fr/customers/1/circle").to route_to("customers#circle", :locale => "fr", :id => "1", "path"=>"fr/customers/1/circle")
    end

    it "routes to #wishlist" do
      expect(:get => "/fr/customers/1/wishlist").to route_to("customers#wishlist", :locale => "fr", :id => "1", "path"=>"fr/customers/1/wishlist")
    end

    it "routes to #reviews_list" do
      expect(:get => "/fr/customers/1/reviews_list").to route_to("customers#reviews_list", :locale => "fr", :id => "1", "path"=>"fr/customers/1/reviews_list")
    end

    it "routes to #dashboard" do
      expect(:get => "/fr/customers/1/dashboard").to route_to("customers#dashboard", :locale => "fr", :id => "1", "path"=>"fr/customers/1/dashboard")
    end
  end
end
