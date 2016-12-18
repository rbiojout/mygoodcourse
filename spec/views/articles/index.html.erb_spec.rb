require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before(:each) do
    I18n.locale = I18n.default_locale
    @current_country = countries(:one)
    @topics = @current_country.topics
    @topic = @topics.first
    @articles = @topic.articles
  end

  it "renders a list of articles" do
    render
  end
end
