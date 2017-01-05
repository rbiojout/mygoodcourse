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

RSpec.describe OrderItemsController, type: :controller do

  # even if not recommended, we test the rendering in the controller
  render_views

  let(:order_item) {order_items(:one)}

  # This should return the minimal set of attributes required to create a valid
  # OrderItem. As you add validations to OrderItem, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {order_id: order_item.order_id, price: order_item.price, product_id: order_item.product_id, tax_amount: order_item.tax_amount, tax_rate: order_item.tax_rate}
  }

  let(:invalid_attributes) {
    {admin: true}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrderItemsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns associated for order_items as @order" do
      get :index, params: {}, session: valid_session
      current_order = assigns(:order)
      expect(current_order).not_to be_nil
    end

    it "assigns all order_items as @order_items" do
      get :index, params: {}, session: valid_session
      current_order = assigns(:order)
      order_items = current_order.order_items
      expect(assigns(:order_items)).to eq(order_items)
    end

    it "assigns products for order_items as @products" do
      get :index, params: {}, session: valid_session
      current_order = assigns(:order)
      order_items = current_order.order_items
      expect(assigns(:products)).to eq(current_order.products)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new OrderItem" do
        expect {
          post :create, order_item: valid_attributes, session: valid_session
        }.to change(OrderItem, :count).by(1)
      end

      it "assigns a newly created order_item as @order_item" do
        post :create, order_item: valid_attributes, session: valid_session
        expect(assigns(:order_item)).to be_a(OrderItem)
        expect(assigns(:order_item)).to be_persisted
      end

      it "redirects to the created order_item" do
        post :create, order_item: valid_attributes, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved order_item as @order_item" do
        post :create, order_item: invalid_attributes, session: valid_session
        expect(response).to have_http_status(200)
      end

    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {order_id: order_item.order_id, price: order_item.price, product_id: order_item.product_id, tax_amount: order_item.tax_amount, tax_rate: order_item.tax_rate}
      }

      it "updates the requested order_item" do
        put :update, id: order_item.to_param, order_item: new_attributes, session: valid_session
        order_item.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested order_item as @order_item" do
        put :update, id: order_item.to_param, order_item: valid_attributes, session: valid_session
        expect(assigns(:order_item)).to eq(order_item)
      end

      it "redirects to the order_item" do
        put :update, id: order_item.to_param, order_item: valid_attributes, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid params" do
      it "assigns the order_item as @order_item" do
        put :update, id: order_item.to_param, order_item: invalid_attributes, session: valid_session
        expect(assigns(:order_item)).to eq(order_item)
      end

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested order_item" do
      expect {
        delete :destroy, id: order_item.to_param, session: valid_session
      }.to change(OrderItem, :count).by(-1)
    end

    it "redirects to the order_items list" do
      delete :destroy, id: order_item.to_param, session: valid_session
      expect(response).to redirect_to(catalog_products_path)
    end
  end

  describe "POST #undo" do
    it "undo deletele for the requested order_item" do
      expect {
        post :undo, product_id: products(:two).id, session: valid_session
      }.to change(OrderItem, :count).by(1)
      expect(assigns(:order_item)).not_to be_nil
    end

    it "redirects to the order_items list" do
      post :undo, product_id: products(:two).id, session: valid_session
      expect(response).to redirect_to(catalog_products_path)
    end
  end

end