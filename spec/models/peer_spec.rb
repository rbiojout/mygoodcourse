require 'rails_helper'

RSpec.describe Peer, type: :model do
  before do
    @peer = peers(:one)
  end

  context 'validation' do
    it 'should be valid' do
      assert @peer.valid?, "peer #{@peer.followed_id}"
    end

    it 'should require a follower_id' do
      @peer.follower = nil
      expect(@peer.valid?).not_to be_truthy
    end

    it 'should require a followed_id' do
      @peer.followed = nil
      expect(@peer.valid?).not_to be_truthy
    end

    it 'should follow and unfollow' do
      c_one = customers(:one)
      c_two = customers(:two)
      expect(c_one.following?(c_two)).to be_truthy
      c_one.unfollow(c_two)
      expect(c_one.following?(c_two)).not_to be_truthy
    end

    it 'customer one followed by customer two' do
      c_one = customers(:one)
      c_two = customers(:two)
      expect(c_one.following?(c_two)).to be_truthy
      expect(c_two.followeds.include?(c_one)).to be_truthy
      expect(c_one.followers.include?(c_two)).to be_truthy
    end
  end
end
