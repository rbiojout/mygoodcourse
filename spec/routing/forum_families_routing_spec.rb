require "rails_helper"

RSpec.describe ForumFamiliesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forum_families").to route_to("forum_families#index")
    end

    it "routes to #show" do
      expect(:get => "/forum_families/1").to route_to("forum_families#show", :id => "1")
    end

  end
end
