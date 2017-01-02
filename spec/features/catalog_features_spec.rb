# save_screenshot is OK
# rubocop:disable Lint/Debugger

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'CatalogFeatures', js: true do
  context 'browse catalog' do
    it 'visit catalog', js: true do
      country = countries(:france)
      visit catalog_products_path(country_id: country.id, locale: I18n.default_locale)
      execute_script('window.scroll(0,document.body.scrollHeight);')
      sleep(1)
      execute_script('window.scroll(0,document.body.scrollHeight);')
      sleep(1)

      save_screenshot("#{::Rails.root}/spec/screenshots/catalog_visit.jpg")
    end

    it 'filter catalog price', js: true do
      country = countries(:france)
      visit catalog_products_path(country_id: country.id,
                                  sort: 'price',
                                  direction: 'desc',
                                  locale: I18n.default_locale)
      execute_script('window.scroll(0,document.body.scrollHeight);')
      sleep(1)
      execute_script('window.scroll(0,document.body.scrollHeight);')
      sleep(1)

      save_screenshot("#{::Rails.root}/spec/screenshots/catalog_visit_price.jpg")
    end
  end
end
