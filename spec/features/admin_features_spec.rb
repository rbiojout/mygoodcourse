# save_screenshot is OK
# rubocop:disable Lint/Debugger

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'CatalogFeatures' do

  before(:each) do
    login_as employees(:one), scope: :employee
  end

  context 'admin customer' do
    let(:customer) { customers(:one)}

    it 'list customers' do
      visit "/admin/customer"
      expect(page).to have_content(customer.name)
    end

    it 'show customer' do
      visit "/admin/customer/#{customer.id}"
      expect(page).to have_content(customer.name)
    end

    it 'edit customer' do
      visit "/admin/customer/#{customer.id}/edit"
      expect(page).to have_content(customer.name)
    end
  end

  context 'admin employee' do
    let(:employee) { employees(:one)}

    it 'list employees' do
      visit "/admin/employee"
      expect(page).to have_content(employee.name)
    end

    it 'show employee' do
      visit "/admin/employee/#{employee.id}"
      expect(page).to have_content(employee.name)
    end

    it 'edit employee' do
      visit "/admin/employee/#{employee.id}/edit"
      expect(page).to have_content(employee.name)
    end
  end

  context 'admin country' do
    let(:country) { countries(:one)}

    it 'list countries' do
      visit "/admin/country"
      expect(page).to have_content(country.name)
    end

    it 'show country' do
      visit "/admin/country/#{country.id}"
      expect(page).to have_content(country.name)
    end

    it 'edit country' do
      visit "/admin/country/#{country.id}/edit"
      expect(page).to have_content(country.name)
    end
  end

  context 'admin product' do
    let(:product) { products(:one)}

    it 'list products' do
      visit "/admin/product"
      expect(page).to have_content(product.name)
    end

    it 'show product' do
      visit "/admin/product/#{product.id}"
      expect(page).to have_content(product.name)
    end

    it 'edit product' do
      visit "/admin/product/#{product.id}/edit"
      expect(page).to have_content(product.name)
    end
  end

  ## custom actions

  ## abuse
  context 'admin abuse' do
    let(:abuse) { abuses(:review_one)}

    it 'list abuses' do
      visit "/admin/abuse"
      expect(page).to have_content(abuse.id)
    end

    it 'show abuse' do
      visit "/admin/abuse/#{abuse.id}"
      expect(page).to have_content(abuse.id)
    end

    it 'edit abuse' do
      visit "/admin/abuse/#{abuse.id}/edit"
      expect(page).to have_content(abuse.id)
    end

    it 'change state' do
      visit "/admin/abuse/#{abuse.id}/receive_state"
      abuse.reload
      expect(abuse.received?).to be_truthy

      visit "/admin/abuse/#{abuse.id}/accept_state"
      abuse.reload
      expect(abuse.accepted?).to be_truthy

      visit "/admin/abuse/#{abuse.id}/cancel_state"
      abuse.reload
      expect(abuse.received?).to be_truthy

      visit "/admin/abuse/#{abuse.id}/reject_state"
      abuse.reload
      expect(abuse.rejected?).to be_truthy

    end
  end



  ## stats
  context 'admin custom stats' do
    it 'give stats' do
      visit '/admin/stats_users'
    end
  end

end
