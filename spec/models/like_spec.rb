require 'rails_helper'

RSpec.describe Family, type: :model do

  context "validation" do
    it "validate like for Product" do
      customer = customers(:one)
      product = products(:one)
      like_for_prod = likes(:cust_one_prod_one)

      expect(like_for_prod).not_to be_nil

      expect(product.liked?(customer)).to be_truthy
    end

    it "validate like for Review" do
      customer = customers(:one)
      review = reviews(:one)
      like_for_review = likes(:cust_one_review_one)

      expect(like_for_review).not_to be_nil

      expect(review.liked?(customer)).to be_truthy
    end
  end

end
