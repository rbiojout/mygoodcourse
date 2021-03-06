require "rails_helper"

RSpec.describe LevelsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/levels").to route_to("levels#index", "path"=>"levels")
    end

    it "routes to #show" do
      expect(:get => "/levels/1").to route_to("levels#show", :id => "1", "path"=>"levels/1")
    end

    it "routes to #sort" do
      expect(:post => "/levels/sort").to route_to("levels#sort", "path"=>"levels/sort")
    end

  end
end
