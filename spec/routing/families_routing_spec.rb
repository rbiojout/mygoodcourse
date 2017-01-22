require "rails_helper"

RSpec.describe FamiliesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/families").to route_to("families#index", "path"=>"families")
    end

    it "routes to #show" do
      expect(:get => "/families/1").to route_to("families#show", :id => "1", "path"=>"families/1")
    end

    it "routes to #sort" do
      expect(:post => "/families/sort").to route_to("families#sort", "path"=>"families/sort")
    end

  end
end
