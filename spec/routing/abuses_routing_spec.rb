require "rails_helper"

RSpec.describe AbusesController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/abuses/new").to route_to("abuses#new")
    end

    it "routes to #create" do
      expect(:post => "/abuses").to route_to("abuses#create")
    end

  end
end
