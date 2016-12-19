require "rails_helper"

RSpec.describe OrdersController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/orders/1").to route_to("orders#show", :id => "1")
    end

    it "routes to #myorders" do
      expect(:get => '/orders/myorders').to route_to('orders#myorders')
    end

    it 'routes to #checkout' do
      expect(:get => "/checkout").to route_to("orders#checkout")
    end

    it 'routes to #confirmation' do
      expect(:get => "/checkout/confirm").to route_to("orders#confirmation")
    end

  end
end
