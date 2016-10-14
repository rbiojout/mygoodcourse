# == Schema Information
#
# Table name: stripe_cards
#
#  id                 :integer          not null, primary key
#  stripe_id          :string
#  name               :string
#  brand              :string
#  exp_month          :integer
#  exp_year           :integer
#  last4              :integer
#  country            :string
#  default_source     :boolean          default(FALSE)
#  stripe_customer_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_stripe_cards_on_stripe_customer_id  (stripe_customer_id)
#
# Foreign Keys
#
#  fk_rails_2ae19963e4  (stripe_customer_id => stripe_customers.id)
#

  class StripeCard < ActiveRecord::Base
    belongs_to :stripe_customer, :class_name => 'StripeCustomer', foreign_key: 'stripe_customer_id'
  end

