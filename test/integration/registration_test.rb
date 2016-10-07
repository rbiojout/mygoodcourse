require 'test_helper'

# we use accounts from Skipe
# fmc.buyer1@gmail.com, fmc.buyer2@gmail.com, fmc.seller1@gmail.com, fmc.seller2@gmail.com
# IBAN FR1420041010050500013M02606

class RegistrationTest < ActionDispatch::IntegrationTest

  test "should login" do
    visit('/')
    click_on(I18n.translate('customers.sessions.new.sign_in'))
    customer = customers(:one)
    within("#sign_in") do
      fill_in(I18n.translate('activerecord.attributes.customer.email'), :with => customer.email)
      fill_in(I18n.translate('activerecord.attributes.customer.password'), :with => customer.password)
      within("#new_customer") do
        click_on(I18n.translate('customers.sessions.new.sign_in'))
      end
    end

  end

end
