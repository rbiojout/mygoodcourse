require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature "catalog visit", js: true do

  context 'browse catalog' do

    it 'visit catalog', js: true do
      country = countries(:france)
      visit catalog_products_path(country_id: country.id, locale: I18n.default_locale)
      execute_script('window.scroll(0,document.body.scrollHeight);')
      sleep(1)
      execute_script('window.scroll(0,document.body.scrollHeight);')
      sleep(1)
      save_screenshot("#{::Rails.root}/spec/screenshots/catalog_visit.jpg", full: true)
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
      save_screenshot("#{::Rails.root}/spec/screenshots/catalog_visit_price.jpg", full: true)
    end
  end

end