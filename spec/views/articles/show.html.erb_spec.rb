require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  before(:each) do
    I18n.locale = I18n.default_locale
    @current_country = countries(:one)
    @topics = @current_country.topics
    @topic = @topics.first
    @articles = @topic.articles
    @article = @articles.first
  end

  it "renders attributes in <p>" do
    render
  end
end
