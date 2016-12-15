require 'test_helper'

class ForumCategoriesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @forum_category = forum_categories(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_categories)
  end

  test 'should show forum_category' do
    get :show, id: @forum_category
    assert_response :success
  end
end
