require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @family = families(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:families)
  end

  test 'should show family' do
    get :show, id: @family
    assert_response :success
  end

  test 'should sort families if logged' do
    assert(families(:one).position == 1)
    assert(families(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'family' => [families(:two).id.to_s, families(:one).id.to_s] do
      assert(families(:one).position == 2)
      assert(families(:two).position == 1)
    end
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response :success
  end

  test 'should not sort families if not logged' do
    assert(families(:one).position == 1)
    assert(families(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    sign_out(:employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'family' => [families(:two).id.to_s, families(:one).id.to_s]
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response 302
  end
end
