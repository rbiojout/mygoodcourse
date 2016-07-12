require 'test_helper'

class LevelsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @level = levels(:one)
    # add a signed employee to perform the tests
    sign_in :employee, (employees(:one))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create level" do
    cycle = Cycle.find(@level.cycle_id)
    last_position = cycle.levels.last.position
    assert_difference('Level.count') do
      post :create, level: { cycle_id: @level.cycle_id, description: @level.description, name: @level.name, position: @level.position }
    end

    assert_redirected_to level_path(assigns(:level))
    new_position = cycle.levels.last.position
    assert (new_position-last_position == 1)

  end

  test "should show level" do
    get :show, id: @level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @level
    assert_response :success
  end

  test "should update level" do
    patch :update, id: @level, level: { cycle_id: @level.cycle_id, description: @level.description, name: @level.name, position: @level.position }
    assert_redirected_to level_path(assigns(:level))
  end

  test "should destroy level" do
    assert_difference('Level.count', -1) do
      delete :destroy, id: @level
    end

    assert_redirected_to levels_path
  end
end
