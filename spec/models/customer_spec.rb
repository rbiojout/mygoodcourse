require 'rails_helper'

RSpec.describe Customer, type: :model do

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:name) }

  it "has a valid factory" do
    @customer = build(:customer, :first_name => "Johnny", :name => "Bravo")
    expect(@customer).to be_valid
  end

end
