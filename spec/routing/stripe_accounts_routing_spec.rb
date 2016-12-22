require "rails_helper"

RSpec.describe StripeAccountsController, type: :routing do
  describe "routing" do

    it "no routes to #new" do
      expect(:get => "/stripe_accounts/new").not_to be_routable
    end

    it "no routes to #show" do
      expect(:get => "/stripe_accounts/1").not_to be_routable
    end

    it "no routes to #edit" do
      expect(:get => "/stripe_accounts/1/edit").not_to be_routable
    end

    it "no routes to #create" do
      expect(:post => "/stripe_accounts").not_to be_routable
    end

    it "no routes to #update via PUT" do
      expect(:put => "/stripe_accounts/1").not_to be_routable
    end

    it "no routes to #update via PATCH" do
      expect(:patch => "/stripe_accounts/1").not_to be_routable
    end

    it "no routes to #destroy" do
      expect(:delete => "/stripe_accounts/1").not_to be_routable
    end

    it 'routes to #oauth' do
      expect(:get => '/connect/oauth').to route_to('stripe_accounts#oauth')
    end

    it 'routes to #confirm' do
      expect(:get => '/connect/confirm').to route_to('stripe_accounts#confirm')
    end

    it 'routes to #deauthorize' do
      expect(:get => '/connect/deauthorize').to route_to('stripe_accounts#deauthorize')
    end

    it 'routes to #managed' do
      expect(:post => '/connect/managed').to route_to('stripe_accounts#managed')
    end

    it 'routes to #standalone' do
      expect(:post => '/connect/standalone').to route_to('stripe_accounts#standalone')
    end
  end
end
