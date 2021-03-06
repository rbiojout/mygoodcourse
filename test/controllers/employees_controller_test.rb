require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @employee = employees(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:employees)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create employee' do
    assert_difference('Employee.count') do
      post :create, employee: {email: 'tralala@test.com', password: 'tralala1*', password_confirmation: 'tralala1*', active: @employee.active, entry_date: @employee.entry_date, first_name: @employee.first_name, mobile: @employee.mobile, name: @employee.name, picture: @employee.picture, role: @employee.role}
    end

    assert_redirected_to employee_path(assigns(:employee))
  end

  test 'should show employee' do
    get :show, id: @employee
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @employee
    assert_response :success
  end

  test 'should update employee' do
    patch :update, id: @employee, employee: {active: @employee.active, entry_date: @employee.entry_date, first_name: @employee.first_name, mobile: @employee.mobile, name: @employee.name, picture: @employee.picture, role: @employee.role}
    assert_redirected_to employee_path(assigns(:employee))
  end

  test 'should destroy employee' do
    assert_difference('Employee.count', -1) do
      delete :destroy, id: @employee
    end

    assert_redirected_to employees_path
  end
end
