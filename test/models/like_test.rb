require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should validate like for Product' do
    customer = customers(:one)
    product = products(:one)
    like_for_prod = likes(:cust_one_prod_one)

    assert_not_nil like_for_prod

    assert product.liked?(customer)
  end

  test 'should validate like for Review' do
    customer = customers(:one)
    review = reviews(:one)
    like_for_review = likes(:cust_one_review_one)

    assert_not_nil like_for_review

    assert review.liked?(customer)
  end
end
