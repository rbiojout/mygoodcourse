require 'test_helper'

class ForumAnswersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @forum_answer = forum_answers(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_answers)
  end

  test 'should get new' do
    get :new, forum_subject_id: @forum_answer.forum_subject_id
    assert_response :success
  end

  test 'should create forum_answer' do
    assert_difference('ForumAnswer.count') do
      post :create, forum_answer: {customer_id: @forum_answer.customer_id, forum_subject_id: @forum_answer.forum_subject_id, text: @forum_answer.text}
    end

    assert_redirected_to forum_subject_path(assigns(:forum_answer).forum_subject)
  end

  test 'should create forum_answer via ajax' do
    get :new, xhr: true, forum_subject_id: @forum_answer.forum_subject_id
    assert_response :success

    assert_difference('ForumAnswer.count') do
      post :create, xht: true, forum_answer: {customer_id: @forum_answer.customer_id, forum_subject_id: @forum_answer.forum_subject_id, text: @forum_answer.text}
    end

    assert_redirected_to forum_subject_path(assigns(:forum_answer).forum_subject)
  end

  test 'should show forum_answer' do
    get :show, id: @forum_answer
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @forum_answer
    assert_response :success
  end

  test 'should update forum_answer' do
    patch :update, id: @forum_answer, forum_answer: {customer_id: @forum_answer.customer_id, forum_subject_id: @forum_answer.forum_subject_id, text: @forum_answer.text}
    assert_redirected_to forum_answer_path(assigns(:forum_answer))
  end

  test 'should destroy forum_answer' do
    assert_difference('ForumAnswer.count', -1) do
      delete :destroy, id: @forum_answer
    end

    assert_redirected_to forum_subject_path(forum_answers(:one).forum_subject)
  end
end
