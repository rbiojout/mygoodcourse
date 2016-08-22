require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @topic = topics(:one)
  end

  test "should get index" do
    get :index, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:topics)
  end

  test "should get new" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    get :new, locale: I18n.default_locale
    assert_response :success
  end

  test "should create topic" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    assert_difference('Topic.count') do
      post :create, locale: I18n.default_locale, topic: { country_id: @topic.country_id, description: @topic.description, name: @topic.name, position: @topic.position, slug: @topic.slug }
    end

    assert_redirected_to topic_path(assigns(:topic))
  end

  test "should show topic" do
    get :show, locale: I18n.default_locale, id: @topic
        assert_response :success
  end

  test "should protect edit" do
    get :edit, id: @topic, locale: I18n.default_locale
    assert_redirected_to new_employee_session_path
  end

  test "should get edit" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    get :edit, id: @topic, locale: I18n.default_locale
    assert_response :success
  end

  test "should update topic" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    patch :update, locale: I18n.default_locale, id: @topic, topic: { country_id: @topic.country_id, description: @topic.description, name: @topic.name, position: @topic.position, slug: @topic.slug }
    assert_redirected_to topic_path(assigns(:topic))
  end

  test "should destroy topic" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    assert_difference('Topic.count', -1) do
      delete :destroy, locale: I18n.default_locale, id: @topic
    end

    assert_redirected_to topics_path
  end
end
