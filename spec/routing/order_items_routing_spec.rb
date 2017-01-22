require "rails_helper"

RSpec.describe OrderItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/order_items").to route_to("order_items#index", "path"=>"order_items")
    end

    it "routes to #new" do
      expect(:get => "/order_items/new").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/order_items/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/order_items/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/order_items").to route_to("order_items#create", "path"=>"order_items")
    end

    it "routes to #update via PUT" do
      expect(:put => "/order_items/1").to route_to("order_items#update", :id => "1", "path"=>"order_items/1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/order_items/1").to route_to("order_items#update", :id => "1", "path"=>"order_items/1")
    end

    it "routes to #destroy" do
      expect(:delete => "/order_items/1").to route_to("order_items#destroy", :id => "1", "path"=>"order_items/1")
    end

    it "routes to #undo" do
      expect(:post => "/order_items/undo").to route_to("order_items#undo", "path"=>"order_items/undo")
    end

  end
end
