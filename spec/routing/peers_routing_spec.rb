require "rails_helper"

RSpec.describe PeersController, type: :routing do
  describe "routing" do

    it "no routes to #new" do
      expect(:get => "/peers/new").not_to be_routable
    end

    it "no routes to #show" do
      expect(:get => "/peers/1").not_to be_routable
    end

    it "no routes to #edit" do
      expect(:get => "/peers/1/edit").not_to be_routable
    end

    it "no routes to #create" do
      expect(:post => "/peers").not_to be_routable
    end

    it "no routes to #update via PUT" do
      expect(:put => "/peers/1").not_to be_routable
    end

    it "no routes to #update via PATCH" do
      expect(:patch => "/peers/1").not_to be_routable
    end

    it "no routes to #destroy" do
      expect(:delete => "/peers/1").not_to be_routable
    end

    it 'routes to #follow' do
      expect(:post => '/peers/follow').to route_to('peers#follow')
    end

    it 'routes to #unfollow' do
      expect(:delete => '/peers/unfollow').to route_to('peers#unfollow')
    end

  end
end
