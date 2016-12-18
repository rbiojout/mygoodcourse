require 'rails_helper'

RSpec.describe "comments/new", type: :view do

  it "renders new comment form for Post" do
    @context = posts(:one)
    @comment = @context.comments.build
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do
    end
  end

  it "renders new comment form for ForumAnswer" do
    @context = forum_answers(:one)
    @comment = @context.comments.build
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do
    end
  end
end
