require 'test_helper'

class LevelsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @level = levels(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:levels)
  end

  test 'should show level' do
    get :show, id: @level
    assert_response :success
  end

  test 'should sort levels if logged' do
    assert(levels(:one).position == 1)
    assert(levels(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'level' => [levels(:two).id.to_s, levels(:one).id.to_s] do
      assert(levels(:one).position == 2)
      assert(levels(:two).position == 1)
    end
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response :success
  end

  test 'should not sort levels if not logged' do
    assert(levels(:one).position == 1)
    assert(levels(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    sign_out(:employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'level' => [levels(:two).id.to_s, levels(:one).id.to_s]
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response 302
  end
end
