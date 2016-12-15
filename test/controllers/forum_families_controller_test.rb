require 'test_helper'

class ForumFamiliesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @forum_family = forum_families(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_families)
  end

  test 'should show forum_family' do
    get :show, id: @forum_family
    assert_response :success
  end
end
