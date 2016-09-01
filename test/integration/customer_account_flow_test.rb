require 'test_helper'

class CustomerAccountFlowTest < ActionDispatch::IntegrationTest
  #include Warden::Test::Helpers
  #include Devise::Test::ControllerHelpers

  test "should create customer" do
    # login via https
    https!(false)

    # start registration
    get '/customers/sign_up', locale: I18n.default_locale
    assert_equal 200, status

    @customer = customers(:one)

    puts 'added blocked'

    # we test with the same user (same email)
    post customers_path, customer: { email: @customer.email, password: 'tralala1*', password_confirmation: 'tralala1*', first_name: @customer.first_name, mobile: @customer.mobile, name: @customer.name }, locale: I18n.default_locale
    assert_equal 200, status
    assert_equal [I18n.t('errors.messages.taken')], assigns(:customer).errors[:email]

    puts 'added ok'
    # we test with a new user (different email)
    post customers_path, customer: { email: 'tralala@test.com', password: 'tralala1*', password_confirmation: 'tralala1*', first_name: @customer.first_name, mobile: @customer.mobile, name: @customer.name }, locale: I18n.default_locale
    assert_equal 302, status

    puts assigns(:customer).email

    puts 'remove'
    # we delete the account
    delete customer_path(id: @customer.id, locale: I18n.default_locale)
    assert_equal 200, status

    # we recreate the account
    post customers_path, customer: { email: @customer.email, password: 'tralala1*', password_confirmation: 'tralala1*', first_name: @customer.first_name, mobile: @customer.mobile, name: @customer.name }, locale: I18n.default_locale
    assert_equal 200, status


  end



end
