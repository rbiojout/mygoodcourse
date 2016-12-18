require 'rails_helper'

RSpec.describe "cycles/show", type: :view do
  before(:each) do
    @cycle = cycles(:one)
  end

  it "renders attributes in <p>" do
    render
  end
end
