require 'test_helper'

class PeersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  # test "the truth" do
  #   assert true
  # end

  test "should follow" do
    assert_difference('Peer.count') do
      post :follow, followed_id: customers(:seller_one)
    end
  end

  test "should follow via ajax" do
    assert_difference('Peer.count') do
      xhr :post, :follow, followed_id: customers(:seller_one)
    end
    assert_response :success

  end

  test "should unfollow" do
    assert_difference('Peer.count', -1) do
      delete :unfollow, followed_id: customers(:two)
    end
  end

  test "should unfollow via ajax" do
    assert_difference('Peer.count',-1) do
      xhr :delete, :unfollow, followed_id: customers(:two)
    end
    assert_response :success

  end

end
