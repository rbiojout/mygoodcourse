require "rails_helper"

RSpec.describe LikesController, type: :routing do
  describe "routing" do

    it "routes to #like" do
      expect(:post => "/likes/like").to route_to("likes#like")
    end

    it "routes to #unlike" do
      expect(:delete => "/likes/unlike").to route_to("likes#unlike")
    end

  end
end
