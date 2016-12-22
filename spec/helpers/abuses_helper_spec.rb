require "rails_helper"

RSpec.describe AbusesHelper, :type => :helper do

  describe 'print a name' do
    it 'print a name for comment' do
      abuse = abuses(:comment_one)
      expect(abusable_name(abuse)).to eq(Comment.model_name.human)
    end

    it 'print a name for customer' do
      abuse = abuses(:customer_one)
      expect(abusable_name(abuse)).to eq(Customer.model_name.human+": #{customers(:one).name}")
    end

    it 'print a name for product' do
      abuse = abuses(:product_one)
      expect(abusable_name(abuse)).to eq(Product.model_name.human+": #{products(:one).name}")
    end

    it 'print a name for review' do
      abuse = abuses(:review_one)
      expect(abusable_name(abuse)).to eq(Review.model_name.human+": #{reviews(:one).title}")
    end
  end
end
