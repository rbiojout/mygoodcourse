require 'rails_helper'

RSpec.describe "comments/show", type: :view do
  before(:each) do
    @comment = comments(:one)
    @context = @comment.commentable
  end

  it "renders attributes in <p>" do
    render
  end
end
