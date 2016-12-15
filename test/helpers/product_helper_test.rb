class ProductHelperTest < ActionView::TestCase
  include ProductsHelper
  include Devise::Test::ControllerHelpers

  setup do
    @product = products(:one)
    # add a signed customer to perform the tests
    @customer = customers(:one)
  end

  def test_nothing
    assert true
  end

  test 'should recognize already ordered' do
    sign_in(@customer, scope: :customer)
    assert already_bought(@product, @customer), 'product not found for customer'
  end

  test 'should not consider bad status' do
    @product = products(:product_with_order_rejected)
    @customer = customers(:customer_with_rejected_orders)
    sign_in(@customer, scope: :customer)
    assert_not already_bought(@product, @customer), 'product found for customer'
  end
end
