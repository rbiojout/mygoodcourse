require 'rails_helper'

RSpec.describe "cycles/index", type: :view do
  before(:each) do
    @current_country = countries(:one)
    @cycles = @current_country.cycles
  end

  it "renders a list of cycles" do
    render
  end
end
