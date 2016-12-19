require "rails_helper"

RSpec.describe CyclesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cycles").to route_to("cycles#index")
    end

    it "routes to #show" do
      expect(:get => "/cycles/1").to route_to("cycles#show", :id => "1")
    end

  end
end
