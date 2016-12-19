require "rails_helper"

RSpec.describe ForumCategoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forum_categories").to route_to("forum_categories#index")
    end

    it "routes to #show" do
      expect(:get => "/forum_categories/1").to route_to("forum_categories#show", :id => "1")
    end

  end
end
