require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe CustomersController, type: :controller do

  # even if not recommended, we test the rendering in the controller
  render_views

  before do
    @customer = customers(:one)
    @request.env['user_mailer.mapping'] = Devise.mappings[:customer]
  end

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {email: @customer.email, first_name: @customer.first_name, mobile: @customer.mobile, name: @customer.name, picture: @customer.picture}
  }

  let(:invalid_attributes) {
    { admin: true }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CustomersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all customers as @customers" do
      get :index, locale: I18n.default_locale, params: {}, session: valid_session
      expect(assigns(:customers)).not_to be_nil
    end
  end

  describe "GET #show" do
    it "assigns the requested customer as @customer" do
      get :show, locale: I18n.default_locale, id: @customer, session: valid_session
      expect(assigns(:customer)).to eq(@customer)
    end

    it 'should impression show customer' do
      customer = customers(:one)
      expect {
        get :show, locale: I18n.default_locale, id: customer
        customer.reload
      }.to change(customer, :counter_cache).by(1)
    end
  end

  describe "GET #edit" do
    it "assigns the requested customer as @customer" do
      sign_in(@customer, scope: :customer)
      get :edit, locale: I18n.default_locale, id: @customer, session: valid_session
      expect(assigns(:customer)).to eq(@customer)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {email: @customer.email, first_name: @customer.first_name, mobile: @customer.mobile, name: @customer.name, picture: @customer.picture}
      }

      it "assigns the requested customer as @customer if signed" do
        sign_in(@customer, scope: :customer)
        put :update, locale: I18n.default_locale, id: @customer, customer: valid_attributes, session: valid_session
        expect(assigns(:customer)).to eq(@customer)
      end

      it "redirects to the customer" do
        sign_in(@customer, scope: :customer)
        put :update, locale: I18n.default_locale, id: @customer, customer: valid_attributes, session: valid_session
        expect(response).to redirect_to(customer_path(id: @customer.slug))
      end

      it "prevent update customer if not signed" do
        sign_out(@customer)
        put :update, locale: I18n.default_locale, id: @customer, customer: valid_attributes, session: valid_session
        expect(response).to redirect_to(new_customer_session_path)
      end

      it "prevent update customer for wrong user" do
        sign_out(@customer)
        sign_in(customers(:two), scope: :customer)
        put :update, locale: I18n.default_locale, id: @customer, customer: valid_attributes, session: valid_session
        expect(response).to redirect_to(catalog_products_path)
      end
    end

    context "with invalid params" do
      it "assigns the customer as @customer" do
        put :update, locale: I18n.default_locale, id: @customer, customer: invalid_attributes, session: valid_session
        expect(assigns(:customer)).to eq(@customer)
      end

      it "re-renders the 'edit' template" do
        sign_in(customers(:one), scope: :customer)
        put :update, locale: I18n.default_locale, id: @customer, customer: invalid_attributes, session: valid_session
        expect(response).to redirect_to(customer_path(id: @customer.slug))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested customer if no order" do
      expect {
        delete :destroy, locale: I18n.default_locale, id: customers(:customer_without_orders), session: valid_session
      }.to change(Customer, :count).by(-1)
    end

    it "not destroys the requested customer if orders" do
      expect {
        delete :destroy, locale: I18n.default_locale, id: customers(:one), session: valid_session
      }.to change(Customer, :count).by(0)
      expect(response).to redirect_to(catalog_products_path)
    end
  end

  render_views

  describe "GET #circle" do
    it 'should have circle' do
      # test the routing with customer one
      get :circle, locale: I18n.default_locale, id: @customer.id
      expect(response).to be_success
      expect(assigns(:followers)).not_to be_nil
      expect(assigns(:followeds)).not_to be_nil

      assert_select 'div#followers'
      assert_select 'div#followeds'

      # we use after a signed user
      sign_in(@customer, scope: :customer)

      get :circle, locale: I18n.default_locale, id: customers(:two).id
      expect(response).to be_success
      expect(assigns(:followers)).not_to be_nil
      expect(assigns(:followeds)).not_to be_nil

      assert_select 'div#followers'
      assert_select 'div#followeds'
    end
  end

  describe "GET #wishlist" do
    it 'should have wishlist' do
      get :wishlist, locale: I18n.default_locale, id: @customer.id
      expect(response).to be_success
      expect(assigns(:products)).not_to be_nil

      # we use after a signed user
      sign_in(@customer, scope: :customer)

      get :wishlist, locale: I18n.default_locale, id: customers(:two).id

      assert_response :success
      expect(assigns(:products)).not_to be_nil
    end

  end

  describe "GET #reviews_list" do
    it 'should have reviews_list' do
      get :reviews_list, locale: I18n.default_locale, id: @customer.id
      expect(response).to be_success
      expect(assigns(:reviews)).not_to be_nil
    end
  end

  describe "GET #dashboard" do
    it 'should have dashboard if signed in' do
      sign_in(@customer, scope: :customer)
      get :dashboard, locale: I18n.default_locale, id: @customer.id
      expect(response).to be_success
    end

    it 'should not have dashboard if not signed in' do
      sign_out(@customer)
      get :dashboard, locale: I18n.default_locale, id: @customer.id
      expect(response).not_to be_success
    end
  end
end
