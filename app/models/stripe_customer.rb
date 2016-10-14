# == Schema Information
#
# Table name: stripe_customers
#
#  id              :integer          not null, primary key
#  stripe_id       :string
#  account_balance :integer
#  currency        :string
#  delinquent      :boolean          default(FALSE)
#  customer_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_stripe_customers_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_1d9a17c961  (customer_id => customers.id)
#

  class StripeCustomer < ActiveRecord::Base
    belongs_to :customer, foreign_key: 'customer_id'

    has_many :stripe_cards, :class_name => 'StripeCard', dependent: :destroy
  end
