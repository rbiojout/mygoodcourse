# == Schema Information
#
# Table name: stripe_accounts
#
#  id                    :integer          not null, primary key
#  customer_id           :integer
#  publishable_key       :string(255)
#  secret_key            :string(255)
#  stripe_user_id        :string(255)
#  currency              :string(255)
#  stripe_account_type   :string(255)
#  stripe_account_status :text             default({})
#
# Indexes
#
#  index_stripe_accounts_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_6090e626be  (customer_id => customers.id)
#

  class StripeAccount < ActiveRecord::Base
    belongs_to :customer, foreign_key: 'customer_id'

    serialize :stripe_account_status, JSON


    # General 'has a StripeAccount account' check
    def connected?; !stripe_user_id.nil?; end

    # StripeAccount account type checks
    def managed?; stripe_account_type == 'managed'; end
    def standalone?; stripe_account_type == 'standalone'; end
    def oauth?; stripe_account_type == 'oauth'; end

    def manager
      case stripe_account_type
        when 'managed' then StripeManaged.new(self)
        when 'standalone' then StripeStandalone.new(self)
        when 'oauth' then StripeOauth.new(self)
      end
    end

    def can_accept_charges?
      return true if oauth?
      return true if managed? && stripe_account_status['charges_enabled']
      return true if standalone? && stripe_account_status['charges_enabled']
      return false
    end

  end

