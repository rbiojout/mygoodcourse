# save_screenshot is OK
# rubocop:disable Lint/Debugger

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'AbuseFeatures', type: :feature, js: true do
  context 'review' do
    scenario 'create abuse for review', js: true do
      customer = customers(:one)
      login_as customer, scope: :customer
      product = products(:one)
      visit product_path(product, locale: I18n.default_locale)

      review = product.reviews.first

      # show the reviews
      find('#product_score').click
      # page.execute_script('show_reviews();')


      expect(page).to have_css("#review_#{review.id}")

      # We need to scroll because the link is outside the window!!
      scroll_script = "$(window).scrollTop($('#review_#{review.id}').offset().top-80);"
      page.execute_script(scroll_script)

      within("#review_#{review.id}") do
        action = I18n.translate('helpers.action.abuse.create')
        # some strange behavior for click
        # page.execute_script(%Q{$("a[alt='#{action}']").prop("scrollTop", 1000000).trigger('scroll')})
        save_screenshot("#{::Rails.root}/spec/screenshots/abuse_review_create-1.jpg")
        # issue if click ouside window
        # http://louissimoneau.com/2014/01/12/debugging-scroll-event-issues-in-capybara-slash-poltergeist/
        find("a[alt='#{action}']").trigger('click')
      end

      save_screenshot("#{::Rails.root}/spec/screenshots/abuse_review_create-2.jpg")
      # waiting for modal
      find('#app_dialog')
      find('#abuse_description')
      expect(page).to have_content(I18n.translate('helpers.action.abuse.create'))
      expect(page).to have_css('#app_dialog')
      save_screenshot("#{::Rails.root}/spec/screenshots/abuse_review_create-2.jpg", full: true)

      text = 'This is the report for this abuse'
      # test the creation via Ajax call
      expect {
        within('#app_dialog') do
          expect(page).to have_css('textarea#abuse_description')
          # this is a client side action
          # we use jquery to change the value
          page.execute_script("$('textarea#abuse_description').text('#{text}')")
          find('input[name="commit"]').click
        end
        expect(page).to have_no_xpath('//input')
      # we wait to have the request sent to the server
      }.to change(Abuse, :count).by(1)

      save_screenshot("#{::Rails.root}/spec/screenshots/abuse_review_create.jpg", full: true)
    end
  end

  context 'product' do
    scenario 'create abuse for review' do
      customer = customers(:one)
      login_as customer, scope: :customer
      product = products(:one)
      visit product_path(product, locale: I18n.default_locale)

      expect(page).to have_css(".product_presentation_#{product.id}")

      within(".product_presentation_#{product.id}") do
        action = I18n.translate('helpers.action.abuse.create')
        # some strange behavior for click
        find("a[alt='#{action}']").click
      end

      # waiting for modal
      find('#app_dialog')
      find('#abuse_description')
      expect(page).to have_css('#app_dialog')
      text = 'This is the report for this abuse'
      # test the creation via Ajax call
      expect {
        within('#app_dialog') do
          expect(page).to have_css('textarea#abuse_description')
          # this is a client side action
          # we use jquery to change the value
          page.execute_script("$('textarea#abuse_description').text('#{text}')")
          find('input[name="commit"]').click
          expect(page).to have_no_xpath('//input')
        end
        # we wait to have the request sent to the server
      }.to change(Abuse, :count).by(1)

      save_screenshot("#{::Rails.root}/spec/screenshots/abuse_product_create.jpg", full: true)
    end
  end

  pending "add some tests for comment #{__FILE__}"
end