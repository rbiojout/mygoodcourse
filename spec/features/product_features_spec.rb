# rubocop:disable Lint/Debugger

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'ProductFeatures', type: :feature, js: true do
  context 'update' do
    scenario 'go to update product by click', js: true do
      customer = customers(:one)
      login_as customer, scope: :customer
      product = products(:one)
      visit product_path(product, locale: I18n.default_locale)

      # go to edit the product
      within(".product_presentation_#{product.id}") do
        action = I18n.translate('helpers.action.edit')
        # some strange behavior for click
        expect(page).to have_css("a[alt='#{action}']")
        find("a[alt='#{action}']").click
      end

      save_screenshot("#{::Rails.root}/spec/screenshots/product_update_access.jpg", full: true)
    end

    scenario 'update product by adding new file', js: true do
      customer = customers(:one)
      login_as customer, scope: :customer
      product = products(:one)
      visit edit_product_path(product, locale: I18n.default_locale)

      # add new version
      action = I18n.translate('dialog.product.add_version')
      expect(page).to have_content(action)
      click_link(action)

      # new empty
      expect(page).to have_css("img[src='/images/empty_file.png']")
      save_screenshot("#{::Rails.root}/spec/screenshots/product_update_add_attachment.jpg", full: true)

    end

  end
end
