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

RSpec.describe ForumSubjectsController, type: :controller do

  # even if not recommended, we test the rendering in the controller
  render_views

  before do
    @forum_subject = forum_subjects(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end
  
  # This should return the minimal set of attributes required to create a valid
  # ForumSubject. As you add validations to ForumSubject, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {customer_id: @forum_subject.customer_id, forum_category_id: @forum_subject.forum_category_id, name: @forum_subject.name, text: @forum_subject.text}
  }

  let(:invalid_attributes) {
    {customer_id: @forum_subject.customer_id, forum_category_id: @forum_subject.forum_category_id}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ForumSubjectsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all forum_subjects as @forum_subjects" do
      forum_subject = ForumSubject.all
      get :index, params: {}, session: valid_session
      expect(assigns(:forum_subjects)).to eq(forum_subject)
    end
  end

  describe "GET #show" do
    it "assigns the requested forum_subject as @forum_subject" do
      get :show, params: {id: @forum_subject.to_param}, session: valid_session
      expect(assigns(:forum_subject)).to eq(@forum_subject)
    end
  end

  describe "GET #new" do
    it "assigns a new forum_subject as @forum_subject" do
      get :new, params: {forum_category_id: @forum_subject.forum_category_id}, session: valid_session
      expect(assigns(:forum_subject)).to be_a_new(ForumSubject)
    end
  end

  describe "GET #edit" do
    it "assigns the requested forum_subject as @forum_subject" do
      get :edit, params: {id: @forum_subject.to_param}, session: valid_session
      expect(assigns(:forum_subject)).to eq(@forum_subject)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ForumSubject" do
        expect {
          post :create, params: {forum_subject: valid_attributes}, session: valid_session
        }.to change(ForumSubject, :count).by(1)
      end

      it "assigns a newly created forum_subject as @forum_subject" do
        post :create, params: {forum_subject: valid_attributes}, session: valid_session
        expect(assigns(:forum_subject)).to be_a(ForumSubject)
        expect(assigns(:forum_subject)).to be_persisted
      end

      it "redirects to the created forum_subject" do
        post :create, params: {forum_subject: valid_attributes}, session: valid_session
        expect(response).to redirect_to(forum_category_path(@forum_subject.forum_category))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved forum_subject as @forum_subject" do
        post :create, params: {forum_subject: invalid_attributes}, session: valid_session
        expect(assigns(:forum_subject)).to be_a_new(ForumSubject)
      end

      it "re-renders the 'new' template" do
        post :create, params: {forum_subject: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {customer_id: @forum_subject.customer_id, forum_category_id: @forum_subject.forum_category_id, name: @forum_subject.name, text: @forum_subject.text}
      }

      it "updates the requested forum_subject" do
        put :update, params: {id: @forum_subject.to_param, forum_subject: new_attributes}, session: valid_session
        @forum_subject.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested forum_subject as @forum_subject" do
        put :update, params: {id: @forum_subject.to_param, forum_subject: valid_attributes}, session: valid_session
        expect(assigns(:forum_subject)).to eq(@forum_subject)
      end

      it "redirects to the forum_subject" do
        put :update, params: {id: @forum_subject.to_param, forum_subject: valid_attributes}, session: valid_session
        expect(response).to redirect_to(@forum_subject)
      end
    end

    context "with invalid params" do
      it "assigns the forum_subject as @forum_subject" do
        put :update, params: {id: @forum_subject.to_param, forum_subject: invalid_attributes}, session: valid_session
        expect(assigns(:forum_subject)).to eq(@forum_subject)
      end

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested forum_subject" do
      expect {
        delete :destroy, params: {id: @forum_subject.to_param}, session: valid_session
      }.to change(ForumSubject, :count).by(-1)
    end

    it "redirects to the forum_subjects list" do
      delete :destroy, params: {id: @forum_subject.to_param}, session: valid_session
      expect(response).to redirect_to(forum_subjects_url)
    end
  end

end
