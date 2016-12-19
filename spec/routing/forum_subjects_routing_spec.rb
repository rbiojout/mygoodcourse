require "rails_helper"

RSpec.describe ForumSubjectsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forum_subjects").to route_to("forum_subjects#index")
    end

    it "routes to #new" do
      expect(:get => "/forum_subjects/new").to route_to("forum_subjects#new")
    end

    it "routes to #show" do
      expect(:get => "/forum_subjects/1").to route_to("forum_subjects#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/forum_subjects/1/edit").to route_to("forum_subjects#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/forum_subjects").to route_to("forum_subjects#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/forum_subjects/1").to route_to("forum_subjects#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/forum_subjects/1").to route_to("forum_subjects#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/forum_subjects/1").to route_to("forum_subjects#destroy", :id => "1")
    end

  end
end
