require "rails_helper"

RSpec.describe PaymentsController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/payments/1").to route_to("payments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/payments/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/payments").not_to be_routable
    end

    it "routes to #update via PUT" do
      expect(:put => "/payments/1").not_to be_routable
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payments/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(:delete => "/payments/1").not_to be_routable
    end

    it "routes to #refund" do
      expect(:post => "/payments/1/refund").to route_to("payments#refund", :id => "1")
    end

  end
end
