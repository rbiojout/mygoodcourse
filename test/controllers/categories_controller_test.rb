require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @category = categories(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create category" do
    family = Family.find(@category.family_id)
    last_position = family.categories.last.position
    assert_difference('Category.count') do
      post :create, category: { description: @category.description, family_id: @category.family_id, name: @category.name }
    end
    assert_redirected_to category_path(assigns(:category))
    new_position = family.categories.last.position
    assert (new_position-last_position == 1)
  end

  test "should show category" do
    get :show, id: @category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @category
    assert_response :success
  end

  test "should update category" do
    patch :update, id: @category, category: { description: @category.description, family_id: @category.family_id, name: @category.name }
    assert_redirected_to category_path(assigns(:category))
  end

  test "should destroy category" do
    assert_difference('Category.count', -1) do
      delete :destroy, id: @category
    end

    assert_redirected_to categories_path
  end
end
