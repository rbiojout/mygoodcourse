require 'test_helper'

class ForumSubjectsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @forum_subject = forum_subjects(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_subjects)
  end

  test "should get new" do
    get :new, forum_category_id: @forum_subject.forum_category_id
    assert_response :success
  end

  test "should create forum_subject" do
    assert_difference('ForumSubject.count') do
      post :create, forum_subject: { customer_id: @forum_subject.customer_id, forum_category_id: @forum_subject.forum_category_id, name: @forum_subject.name, text: @forum_subject.text }
    end

    assert_redirected_to forum_category_path(@forum_subject.forum_category)
  end

  test "should show forum_subject" do
    get :show, id: @forum_subject
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forum_subject
    assert_response :success
  end

  test "should update forum_subject" do
    patch :update, id: @forum_subject, forum_subject: { customer_id: @forum_subject.customer_id, forum_category_id: @forum_subject.forum_category_id, name: @forum_subject.name, text: @forum_subject.text }
    assert_redirected_to forum_subject_path(assigns(:forum_subject))
  end

  test "should destroy forum_subject" do
    assert_difference('ForumSubject.count', -1) do
      delete :destroy, id: @forum_subject
    end

    assert_redirected_to forum_subjects_path
  end
end
