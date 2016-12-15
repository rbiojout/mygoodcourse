require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test 'should get home' do
    get :home, locale: I18n.default_locale
    assert_response :success
  end

  test 'should get help' do
    get :help, locale: I18n.default_locale
    assert_response :success
  end

  test 'should get contact' do
    get :contact, locale: I18n.default_locale
    assert_response :success
  end

  test 'should get about' do
    get :about, locale: I18n.default_locale
    assert_response :success
  end

  test 'should get cheating' do
    get :cheating, locale: I18n.default_locale
    assert_response :success
  end
end
