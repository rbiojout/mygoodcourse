require "rails_helper"

RSpec.describe ForumAnswersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forum_answers").to route_to("forum_answers#index")
    end

    it "routes to #new" do
      expect(:get => "/forum_answers/new").to route_to("forum_answers#new")
    end

    it "routes to #show" do
      expect(:get => "/forum_answers/1").to route_to("forum_answers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/forum_answers/1/edit").to route_to("forum_answers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/forum_answers").to route_to("forum_answers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/forum_answers/1").to route_to("forum_answers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/forum_answers/1").to route_to("forum_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/forum_answers/1").to route_to("forum_answers#destroy", :id => "1")
    end

  end
end
