require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @category = categories(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test 'should show category' do
    get :show, id: @category
    assert_response :success
  end

  test 'should sort categories if logged' do
    assert(categories(:one).position == 1)
    assert(categories(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'category' => [categories(:two).id.to_s, categories(:one).id.to_s] do
      assert(categories(:one).position == 2)
      assert(categories(:two).position == 1)
    end
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response :success
  end

  test 'should not sort categories if not logged' do
    assert(categories(:one).position == 1)
    assert(categories(:two).position == 2)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    sign_out(:employee)

    # assert_equal(@order_one.position, 2) do
    post :sort, locale: I18n.default_locale, 'category' => [categories(:two).id.to_s, categories(:one).id.to_s]
    # we Need assigns to recover the modifications from the Controller
    # end

    assert_response 302
  end
end
