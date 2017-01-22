require "rails_helper"

RSpec.describe ArticlesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fr/topics/1/articles").to route_to("controller"=>"articles", "action"=>"index", "path"=>"fr/topics/1/articles", "locale"=>"fr", "topic_id"=>"1")
    end

    it "routes to #new" do
      expect(:get => "/fr/topics/1/articles/new").to route_to("controller"=>"articles", "action"=>"new", "path"=>"fr/topics/1/articles/new", "locale"=>"fr", "topic_id"=>"1")
    end

    it "routes to #show" do
      expect(:get => "/fr/topics/1/articles/1").to route_to("controller"=>"articles", "action"=>"show", "path"=>"fr/topics/1/articles/1", "locale"=>"fr", "topic_id"=>"1", id: "1")
    end

    it "routes to #edit" do
      expect(:get => "/fr/topics/1/articles/1/edit").to route_to("controller"=>"articles", "action"=>"edit", "path"=>"fr/topics/1/articles/1/edit", "locale"=>"fr", "topic_id"=>"1", id: "1")
    end

    it "routes to #create" do
      expect(:post => "/fr/topics/1/articles").to route_to("controller"=>"articles", "action"=>"create", "path"=>"fr/topics/1/articles", "locale"=>"fr", "topic_id"=>"1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fr/topics/1/articles/1").to route_to("controller"=>"articles", "action"=>"update", "path"=>"fr/topics/1/articles/1", "locale"=>"fr", "topic_id"=>"1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fr/topics/1/articles/1").to route_to("articles#update", :locale => 'fr', "path"=>"fr/topics/1/articles/1", :topic_id => "1", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fr/topics/1/articles/1").to route_to("articles#destroy", :locale => 'fr', "path"=> "fr/topics/1/articles/1", :topic_id => "1", :id => "1")
    end

  end
end
