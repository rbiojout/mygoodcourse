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

RSpec.describe PeersController, type: :controller do

  # even if not recommended, we test the rendering in the controller
  render_views

  let(:follower) {customers(:one)}

  before do
    # add a signed customer to perform the tests
    sign_in(follower, scope: :customer)
  end

  # This should return the minimal set of attributes required to create a valid
  # Peer. As you add validations to Peer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PeersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "POST #follow" do
    it "creates a new Peer" do
      expect {
        post :follow, followed_id: customers(:seller_one).id
      }.to change(Peer, :count).by(1)
    end

    it 'assigns a followed @followed' do
      post :follow, followed_id: customers(:seller_one).id
      expect(assigns(:followed)).to eq(customers(:seller_one))
    end

    it 'follow the customer' do
      post :follow, followed_id: customers(:seller_one).id
      expect(follower.following?(customers(:seller_one))).to be_truthy
    end

    it "return to customer" do
      post :follow, followed_id: customers(:seller_one).id
      expect(response).to redirect_to(customer_path(follower))
    end
  end

  describe "DELETE #unfollow" do
    it "delete a Peer" do
      expect {
        delete :unfollow, followed_id: customers(:two).id
      }.to change(Peer, :count).by(-1)
    end

    it 'assigns a customer @followed' do
      delete :unfollow, followed_id: customers(:two).id
      expect(assigns(:followed)).to eq(customers(:two))
    end

    it 'unfollow the customer' do
      delete :unfollow, followed_id: customers(:two).id
      expect(follower.following?(customers(:two))).not_to be_truthy
    end

    it "return to customer" do
      delete :unfollow, followed_id: customers(:two).id
      expect(response).to redirect_to(customer_path(follower))
    end
  end

end