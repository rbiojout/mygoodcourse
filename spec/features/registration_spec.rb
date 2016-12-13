require 'rails_helper'

describe "registration", :type => :feature, :js => true do

  before :all do
    @current_user = create(:customer)
  end

  after :all do
    @current_user.destroy
  end

  scenario 'sign in customer', :js => true do

    # Log In
    visit '/'
    #save_screenshot("#{::Rails.root}/spec/visit_login1.jpg")

    # we use the title to find the link
    click_link("customer-tools")
    click_on(I18n.translate('customers.sessions.new.sign_in'))

    customer = customers(:buyer_one)

    #save_screenshot("#{::Rails.root}/spec/visit_login2.jpg")
    within("#sign_in") do
      fill_in(I18n.translate('activerecord.attributes.customer.email'), :with => customer.email)
      fill_in(I18n.translate('activerecord.attributes.customer.password'), :with => "Helloworld1*")
      #save_screenshot("#{::Rails.root}/spec/visit_login3.jpg")
      find("#new_customer input[type='submit']").click
    end

    #save_screenshot("#{::Rails.root}/spec/visit_login4.jpg")

    # Check that we go to the right page
    expect(find("#dialog-notice")).to have_content(I18n.translate('devise.sessions.signed_in'))
    #save_screenshot("#{::Rails.root}/spec/visit_login5.jpg")

  end

  scenario 'no sign in customer if wrong credential' do

    # Log In
    visit '/'
    # we use the title to find the link
    click_link("customer-tools")
    click_on(I18n.translate('customers.sessions.new.sign_in'))

    customer = customers(:buyer_one)

    within("#sign_in") do
      fill_in(I18n.translate('activerecord.attributes.customer.email'), :with => @current_user.email)
      fill_in(I18n.translate('activerecord.attributes.customer.password'), :with => "Helloworld1*NOTGOOG")
      save_screenshot("#{::Rails.root}/spec/visit_login3.jpg")
      find("#new_customer input[type='submit']").click
    end

    #save_screenshot("#{::Rails.root}/spec/visit_login6.jpg")

    # Check that we go to the right page
    expect(find("#dialog-alert")).to have_content(I18n.translate('devise.failure.not_found_in_database'))
    save_screenshot("#{::Rails.root}/spec/visit_login7.jpg")

  end

  scenario "create user", js: true do
    # Log In
    visit '/'
    save_screenshot("#{::Rails.root}/spec/visit_sign1.jpg")
    # we use the title to find the link
    click_link("customer-tools")

    click_on(I18n.translate('devise.registrations.new.sign_up'))

    within("#sign_up") do
      save_screenshot("#{::Rails.root}/spec/visit_sign2.jpg")
      fill_in(I18n.translate('activerecord.attributes.customer.email'), :with => @current_user.email)
      fill_in(I18n.translate('activerecord.attributes.customer.password'), :with => @current_user.password)
      fill_in(I18n.translate('activerecord.attributes.customer.password_confirmation'), :with => @current_user.password)
      fill_in(I18n.translate('activerecord.attributes.customer.name'), :with => @current_user.name)
      fill_in(I18n.translate('activerecord.attributes.customer.first_name'), :with => @current_user.first_name)
      select(countries(:one).name, from: "customer_country_id")
      select('Français', from: "customer_language")
      check('customer_terms_of_service')
      #fill_in(I18n.translate('activerecord.attributes.customer.country'), :with => countries(:one).id)
      #fill_in(I18n.translate('activerecord.attributes.customer.language'), :with => 'fr')
      save_screenshot("#{::Rails.root}/spec/visit_sign3.jpg")
      within("#new_customer") do
        find('input[name="commit"]').click
        #click(I18n.translate('customers.sessions.new.sign_in'))
      end
    end

    save_screenshot("#{::Rails.root}/spec/visit_sign4.jpg")
    expect(page).to have_content(I18n.translate('devise.registrations.signed_up'))
    save_screenshot("#{::Rails.root}/spec/visit_sign5.jpg")

  end

end




