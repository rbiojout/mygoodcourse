require 'rails_helper'

RSpec.describe "comments/index", type: :view do
  before(:each) do
    @comments = Comment.all
  end

  it "renders a list of comments" do
    render
  end
end
