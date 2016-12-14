require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature "catalog visit", js: true do

  it 'visit catalog' do

    country = countries(:france)

    visit catalog_products_path(country_id: country.id, locale: I18n.default_locale)

    save_screenshot("#{::Rails.root}/spec/screenshots/catalog_visit.jpg", full: true)

  end

end