# save_screenshot is OK
# rubocop:disable Lint/Debugger

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'CheckoutFeatures', type: :feature, js: true do
  context 'add to cart' do

    # create a fresh checkout
    def prepare_cart
      login_as customers(:buyer_two), scope: :customer

      visit product_path(id: products(:free_from_seller_one).id, locale: I18n.default_locale)

      expect(page).to have_content(I18n.translate('dialog.shop.add_cart'))

      within("#product_actions") do
        click_on(I18n.translate('dialog.shop.add_cart'))
      end

      visit product_path(id: products(:one_from_seller_one).id, locale: I18n.default_locale)
      within("#product_actions") do
        click_on(I18n.translate('dialog.shop.add_cart'))
      end

      visit product_path(id: products(:two_from_seller_one).id, locale: I18n.default_locale)
      within("#product_actions") do
        click_on(I18n.translate('dialog.shop.add_cart'))
      end

      visit product_path(id: products(:one_from_seller_two).id, locale: I18n.default_locale)
      within("#product_actions") do
        click_on(I18n.translate('dialog.shop.add_cart'))
      end

      visit product_path(id: products(:one_from_seller_no_stripe).id, locale: I18n.default_locale)
      within("#product_actions") do
        click_on(I18n.translate('dialog.shop.add_cart'))
      end

      visit checkout_path
    end

    scenario 'empty cart', js: true do
      login_as customers(:buyer_two), scope: :customer

      visit checkout_path

      find('#dialog-alert')
      expect(page).to have_content(I18n.t('dialog.shop.alert_empty_cart'))
      save_screenshot("#{::Rails.root}/spec/screenshots/checkout-empty.jpg", full: true)
    end

    scenario 'validate checkout', js: true do
      prepare_cart

      save_screenshot("#{::Rails.root}/spec/screenshots/checkout-prepare.jpg", full: true)

      find('input[data-stripe="number"]').set('4242424242424242')
      find('select[data-stripe="exp-month"]').set('11')
      find('select[data-stripe="exp-month"]').set('2027')
      find('input[data-stripe="cvc"]').set('321')

      click_on(I18n.translate('helpers.action.pay'))

      sleep(1)

      save_screenshot("#{::Rails.root}/spec/screenshots/checkout-prepare-2.jpg", full: true)

      find('#dialog-notice')
      expect(page).to have_content(I18n.t('dialog.shop.notice_pay_accepted'))

      save_screenshot("#{::Rails.root}/spec/screenshots/checkout-ok.jpg", full: true)

      expect(Order.last.accepted?).to be_truthy
    end

    scenario 'bypass pending balance', js: true do
      prepare_cart

      # we have an order

      find('input[data-stripe="number"]').set('4000000000000077')
      find('select[data-stripe="exp-month"]').set('11')
      find('select[data-stripe="exp-month"]').set('2027')
      find('input[data-stripe="cvc"]').set('321')

      click_on(I18n.translate('helpers.action.pay'))

      find('#dialog-notice')
      expect(page).to have_content(I18n.t('dialog.shop.notice_pay_accepted'))

      save_screenshot("#{::Rails.root}/spec/screenshots/checkout-bypass.jpg", full: true)

      expect(Order.last.accepted?).to be_truthy
    end

    scenario 'charge failed even if customer ok', js: true do
      prepare_cart

      # we have an order

      find('input[data-stripe="number"]').set('4000000000000341')
      find('select[data-stripe="exp-month"]').set('11')
      find('select[data-stripe="exp-month"]').set('2027')
      find('input[data-stripe="cvc"]').set('321')

      click_on(I18n.translate('helpers.action.pay'))

      find("#dialog-alert")
      expect(page).to have_content(I18n.t('dialog.shop.alert_rejected_order'))

      save_screenshot("#{::Rails.root}/spec/screenshots/checkout-failed.jpg", full: true)

      expect(Order.last.rejected?).to be_truthy
    end
  end
end