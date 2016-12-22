require "rails_helper"

RSpec.describe ProductsHelper, :type => :helper do

  before do
    @product = products(:one)
    # add a signed customer to perform the tests
    @customer = customers(:one)
  end

  describe "product bought status" do

    it 'not preventing if not logged in' do
      expect(already_bought(@product, nil)).not_to be_truthy
    end

    it 'recognize already ordered' do
      sign_in(@customer, scope: :customer)
      expect(already_bought(@product, @customer)).to be_truthy
    end

    it 'recognize rejected orders' do
      @product = products(:product_with_order_rejected)
      @customer = customers(:customer_with_rejected_orders)
      sign_in(@customer, scope: :customer)
      expect(already_bought(@product, @customer)).not_to be_truthy
    end

  end

  describe 'count impression' do
    pending 'to be added'
  end
end