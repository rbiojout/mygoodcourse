require 'test_helper'

class CyclesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @cycle = cycles(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:cycles)
  end

  test 'should show cycle' do
    get :show, id: @cycle
    assert_response :success
  end

  test 'should sort cycles if logged' do
    assert(cycles(:one).position == 1)
    assert(cycles(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'cycle' => [cycles(:two).id.to_s, cycles(:one).id.to_s] do
      assert(cycles(:one).position == 2)
      assert(cycles(:two).position == 1)
    end
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response :success
  end

  test 'should not sort cycles if not logged' do
    assert(cycles(:one).position == 1)
    assert(cycles(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    sign_out(:employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'cycle' => [cycles(:two).id.to_s, cycles(:one).id.to_s]
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response 302
  end
end
