require 'rails_helper'

feature "create comment" do
  let(:email) { "bob@example.com" }
  let(:password) { "password123" }

  before do User.create!(email: email,
                         password: password, password_confirmation: password)
  end
  # tests will go here...
end