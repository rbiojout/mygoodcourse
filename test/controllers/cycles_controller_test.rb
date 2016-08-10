require 'test_helper'

class CyclesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @cycle = cycles(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cycles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cycle" do
    assert_difference('Cycle.count') do
      post :create, cycle: { description: @cycle.description, name: @cycle.name, position: @cycle.position, country_id: @cycle.country.id }
    end

    assert_redirected_to cycle_path(assigns(:cycle))
  end

  test "should show cycle" do
    get :show, id: @cycle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cycle
    assert_response :success
  end

  test "should update cycle" do
    patch :update, id: @cycle, cycle: { description: @cycle.description, name: @cycle.name, position: @cycle.position, country_id: @cycle.country.id }
    assert_redirected_to cycle_path(assigns(:cycle))
  end

  test "should destroy cycle" do
    assert_difference('Cycle.count', -1) do
      delete :destroy, id: @cycle
    end

    assert_redirected_to cycles_path
  end
end
