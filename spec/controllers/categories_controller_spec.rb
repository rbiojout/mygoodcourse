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

RSpec.describe CategoriesController, type: :controller do

  # even if not recommended, we test the rendering in the controller
  render_views

  before do
    @category = categories(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
  end

  # This should return the minimal set of attributes required to create a valid
  # Category. As you add validations to Category, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {:name => @category.name, :description => @category.description, :family_id => @category.family_id}
  }

  let(:invalid_attributes) {
     {admin: true}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CategoriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all categories as @categories" do
      get :index, params: {}, session: valid_session
      expect(assigns(:categories)).not_to be_nil
    end
  end

  describe "GET #show" do
    it "assigns the requested category as @category" do
      get :show, locale: I18n.default_locale, id: @category.id, session: valid_session
      expect(response).to be_success
      expect(assigns(:category)).to eq(@category)
    end
  end

  describe "GET #sort" do
    it 'sort categories if logged' do
      assert(categories(:one).position == 1)
      assert(categories(:two).position == 2)
      # add a signed employee to perform the tests
      sign_in(employees(:one), scope: :employee)

      # assert_equal(@order_one.position, 2) do
      post :sort, locale: I18n.default_locale, 'category' => [categories(:two).id.to_s, categories(:one).id.to_s] do
        expect(categories(:one).position).to eq(2)
        expect(categories(:two).position).to eq(1)
      end
      # we Need assigns to recover the modifications from the Controller
      # end

      expect(response).to have_http_status(:success)
    end

    it 'not sort categories if not logged' do
      expect(categories(:one).position).to eq(1)
      expect(categories(:two).position).to eq(2)
      # add a signed employee to perform the tests
      sign_in(employees(:one), scope: :employee)
      sign_out(:employee)

      # assert_equal(@order_one.position, 2) do
      post :sort, locale: I18n.default_locale, 'category' => [categories(:two).id.to_s, categories(:one).id.to_s]
      # we Need assigns to recover the modifications from the Controller
      # end

      expect(response).to have_http_status(302)
    end
  end

end
