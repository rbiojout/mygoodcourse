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

RSpec.describe AbusesController, type: :controller do

  before do
    @abuse = abuses(:review_one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  # This should return the minimal set of attributes required to create a valid
  # Abuse. As you add validations to Abuse, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {description: @abuse.description, customer_id: @abuse.customer.id}
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AbusesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #new for a Review" do
    it "assigns a new abuse as @abuse for a Review" do
      get :new, review_id: reviews(:one).id, params: {}, session: valid_session
      expect(assigns(:abuse)).to be_a_new(Abuse)
    end
  end

  describe "POST #create for a Review" do
    context "with valid params" do
      it "not creates an abuse if not signed" do
        sign_out(customers(:one))
        expect {
          post :create, review_id: reviews(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(0)

        expect(response).to redirect_to(new_customer_session_path)
      end

      it "creates a new Abuse" do
        expect {
          post :create, review_id: reviews(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(1)
      end

      it "assigns a newly created abuse as @abuse for a Review" do
        post :create, review_id: reviews(:one).id, abuse: valid_attributes, session: valid_session
        expect(assigns(:abuse)).to be_a(Abuse)
        expect(assigns(:abuse)).to be_persisted
      end

      it "redirects to the created abuse" do
        post :create, review_id: reviews(:one).id, abuse: valid_attributes, session: valid_session
        # check customer
        expect(assigns(:abuse).customer).to eq(customers(:one))

        expect(response).to redirect_to(review_path(id: reviews(:one).id))
      end

      it "creates a new Abuse for a Review via ajax" do
        expect {
          xhr :post, :create, review_id: reviews(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(1)
        assert_response :success

        expect(response).to render_template(:create)

      end
    end

  end

  describe "GET #new for a Product" do
    it "assigns a new abuse as @abuse for a Product" do
      get :new, product_id: products(:one).id, params: {}, session: valid_session
      expect(assigns(:abuse)).to be_a_new(Abuse)
    end
  end

  describe "POST #create for a Product" do
    context "with valid params" do
      it "not creates an abuse if not signed" do
        sign_out(customers(:one))
        expect {
          post :create, product_id: products(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(0)

        expect(response).to redirect_to(new_customer_session_path)
      end

      it "creates a new Abuse" do
        expect {
          post :create, product_id: products(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(1)
      end

      it "assigns a newly created abuse as @abuse for a Product" do
        post :create, product_id: products(:one).id, abuse: valid_attributes, session: valid_session
        expect(assigns(:abuse)).to be_a(Abuse)
        expect(assigns(:abuse)).to be_persisted
      end

      it "redirects to the created abuse" do
        post :create, product_id: products(:one).id, abuse: valid_attributes, session: valid_session
        # check customer
        expect(assigns(:abuse).customer).to eq(customers(:one))

        expect(response).to redirect_to(product_path(products(:one)))
      end

      it "creates a new Abuse for a Product via ajax" do
        expect {
          xhr :post, :create, product_id: products(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(1)
        assert_response :success

        expect(response).to render_template(:create)

      end
    end

  end

  describe "GET #new for a Comment" do
    it "assigns a new abuse as @abuse for a Product" do
      get :new, comment_id: comments(:one).id, params: {}, session: valid_session
      expect(assigns(:abuse)).to be_a_new(Abuse)
    end
  end

  describe "POST #create for a Comment" do
    context "with valid params" do
      it "not creates an abuse if not signed" do
        sign_out(customers(:one))
        expect {
          post :create, comment_id: comments(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(0)

        expect(response).to redirect_to(new_customer_session_path)
      end

      it "creates a new Comment" do
        expect {
          post :create, comment_id: comments(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(1)
      end

      it "assigns a newly created abuse as @abuse for a Comment" do
        post :create, comment_id: comments(:one).id, abuse: valid_attributes, session: valid_session
        expect(assigns(:abuse)).to be_a(Abuse)
        expect(assigns(:abuse)).to be_persisted
      end

      it "redirects to the created abuse" do
        post :create, comment_id: comments(:one).id, abuse: valid_attributes, session: valid_session
        # check customer
        expect(assigns(:abuse).customer).to eq(customers(:one))

        expect(response).to redirect_to(comment_path(comments(:one)))
      end

      it "creates a new Abuse for a Comment via ajax" do
        expect {
          xhr :post, :create, comment_id: comments(:one).id, abuse: valid_attributes, session: valid_session
        }.to change(Abuse, :count).by(1)
        assert_response :success

        expect(response).to render_template(:create)

      end
    end

  end

end
