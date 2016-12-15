require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    @post = create(:post)
    expect(@post).to be_valid
  end
end
