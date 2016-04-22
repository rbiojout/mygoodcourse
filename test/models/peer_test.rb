require 'test_helper'

class PeerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @peer = peers(:one)
  end

  test "should be valid" do
    assert @peer.valid?, "peer #{@peer.followed_id}"
  end

  test "should require a follower_id" do
    @peer.follower = nil
    assert_not @peer.valid?
  end

  test "should require a followed_id" do
    @peer.followed = nil
    assert_not @peer.valid?
  end

  test "should follow and unfollow" do
    c_one = customers(:one)
    c_two = customers(:two)
    assert c_one.following?(c_two)
    c_one.unfollow(c_two)
    assert_not c_one.following?(c_two)

  end

end
