require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get :index, locale: I18n.default_locale, :topic_id => @article.topic_id
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    get :new, locale: I18n.default_locale, :topic_id => @article.topic_id
    assert_response :success
  end

  test "should create article" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    assert_difference('Article.count') do
      post :create, locale: I18n.default_locale, :topic_id => @article.topic_id, article: { description: @article.description, name: @article.name, position: @article.position, slug: @article.slug, topic_id: @article.topic_id, visits: @article.visits }
    end

    assert_redirected_to topic_article_path(assigns(:article), :topic_id => @article.topic_id)
  end

  test "should show article" do
    get :show, locale: I18n.default_locale, :topic_id => @article.topic_id, id: @article
    assert_response :success
  end

  test "should protect edit" do
    sign_out(employees(:one))
    get :edit, locale: I18n.default_locale, :topic_id => @article.topic_id, id: @article
    assert_redirected_to new_employee_session_path
  end

  test "should get edit" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    get :edit, locale: I18n.default_locale, :topic_id => @article.topic_id, id: @article
    assert_response :success
  end

  test "should update article" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    patch :update, locale: I18n.default_locale, :topic_id => @article.topic_id, id: @article, article: { description: @article.description, name: @article.name, position: @article.position, slug: @article.slug, topic_id: @article.topic_id, visits: @article.visits }
    assert_redirected_to topic_article_path(assigns(:article), :topic_id => @article.topic_id)
  end

  test "should destroy article" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    assert_difference('Article.count', -1) do
      delete :destroy, locale: I18n.default_locale, :topic_id => @article.topic_id, id: @article
    end

    assert_redirected_to topic_articles_path(:topic_id => @article.topic_id)
  end

  test "should sort articles" do
    assert(articles(:order_one).position == 1)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)

    @order_one = articles(:order_one)

    #assert_equal(@order_one.position, 2) do
      post :sort, locale: I18n.default_locale, "article"=>[articles(:order_two).id.to_s, articles(:order_one).id.to_s]
      # we Need assigns to recover the modifications from the Controller
    #end
  end
end
