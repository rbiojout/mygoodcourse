require 'rails_helper'

feature 'visit forum' do
  @forum_subject = create(:forum_subject)
  visit forum_subject_path()

end

feature "create comment" do
  let(:email) { "bob@example.com" }
  let(:password) { "password123" }

  before do User.create!(email: email,
                         password: password, password_confirmation: password)
  end

  # Log In
  visit '/'
  click_on(I18n.translate('customers.sessions.new.sign_in'))

  within("#sign_in") do
    fill_in(I18n.translate('activerecord.attributes.customer.email'), :with => customer.email)
    fill_in(I18n.translate('activerecord.attributes.customer.password'), :with => customer.password)
    within("#new_customer") do
      click_on(I18n.translate('customers.sessions.new.sign_in'))
    end
  end

  # Check that we go to the right page
  expect(page).to have_content("Name")

  # tests will go here...
end