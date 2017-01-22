require "rails_helper"

RSpec.describe CountriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/countries").to route_to("countries#index", "path"=>"countries")
    end

    it "routes to #show" do
      expect(:get => "/countries/1").to route_to("countries#show", :id => "1", "path"=>"countries/1")
    end

  end
end
