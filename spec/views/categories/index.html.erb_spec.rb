require 'rails_helper'

RSpec.describe "categories/index", type: :view do
  before(:each) do
    @current_country = countries(:one)
    @categories = @current_country.categories
  end

  it "renders a list of categories" do
    render
  end
end
