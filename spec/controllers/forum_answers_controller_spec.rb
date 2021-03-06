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

RSpec.describe ForumAnswersController, type: :controller do

  # even if not recommended, we test the rendering in the controller
  render_views

  before do
    @forum_answer = forum_answers(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  # This should return the minimal set of attributes required to create a valid
  # ForumAnswer. As you add validations to ForumAnswer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {customer_id: @forum_answer.customer_id, forum_subject_id: @forum_answer.forum_subject_id, text: @forum_answer.text}
  }

  let(:invalid_attributes) {
    { admin: true}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ForumAnswersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all forum_answers as @forum_answers" do
      forum_answer = ForumAnswer.all
      get :index, params: {}, session: valid_session
      expect(assigns(:forum_answers)).to eq(forum_answer)
    end
  end

  describe "GET #show" do
    it "assigns the requested forum_answer as @forum_answer" do
      get :show, params: {forum_subject_id: @forum_answer.forum_subject_id, id: @forum_answer.to_param}, session: valid_session
      expect(assigns(:forum_answer)).to eq(@forum_answer)
    end
  end

  describe "GET #new" do
    it "link to forum_subject needed" do
      get :new, params: {}, session: valid_session
      expect(assigns(:forum_answer)).to be_nil
      expect(response).to redirect_to(forum_families_path)
      expect(flash[:alert]).to eq(I18n.translate('dialog.restricted'))
    end

    it "assigns a new forum_answer as @forum_answer" do
      get :new, params: {forum_subject_id: @forum_answer.forum_subject_id}, session: valid_session
      expect(assigns(:forum_answer)).to be_a_new(ForumAnswer)
    end

    it "assigns a new forum_answer as @forum_answer via ajax" do
      get :new, xhr: true, params: {forum_subject_id: @forum_answer.forum_subject_id}, session: valid_session
      expect(assigns(:forum_answer)).to be_a_new(ForumAnswer)
    end
  end

  describe "GET #edit" do
    it "assigns the requested forum_answer as @forum_answer" do
      get :edit, params: {id: @forum_answer.to_param}, session: valid_session
      expect(assigns(:forum_answer)).to eq(@forum_answer)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ForumAnswer" do
        expect {
          post :create, params: {forum_answer: valid_attributes}, session: valid_session
        }.to change(ForumAnswer, :count).by(1)
      end

      it "assigns a newly created forum_answer as @forum_answer" do
        post :create, params: {forum_answer: valid_attributes}, session: valid_session
        expect(assigns(:forum_answer)).to be_a(ForumAnswer)
        expect(assigns(:forum_answer)).to be_persisted
      end

      it "redirects to the created forum_answer" do
        post :create, params: {forum_answer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(forum_subject_path(@forum_answer.forum_subject))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved forum_answer as @forum_answer" do
        post :create, params: {forum_answer: invalid_attributes}, session: valid_session
        expect(assigns(:forum_answer)).to be_a_new(ForumAnswer)
      end

      it "re-renders the 'new' template" do
        post :create, params: {forum_answer: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {customer_id: @forum_answer.customer_id, forum_subject_id: @forum_answer.forum_subject_id, text: @forum_answer.text}
      }

      it "updates the requested forum_answer" do
        put :update, params: {id: @forum_answer.to_param, forum_answer: new_attributes}, session: valid_session
        @forum_answer.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested forum_answer as @forum_answer" do
        put :update, params: {id: @forum_answer.to_param, forum_answer: valid_attributes}, session: valid_session
        expect(assigns(:forum_answer)).to eq(@forum_answer)
      end

      it "redirects to the forum_answer" do
        put :update, params: {id: @forum_answer.to_param, forum_answer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(@forum_answer)
      end
    end

    context "with invalid params" do
      it "assigns the forum_answer as @forum_answer" do
        put :update, params: {id: @forum_answer.to_param, forum_answer: invalid_attributes}, session: valid_session
        expect(assigns(:forum_answer)).to eq(@forum_answer)
      end

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested forum_answer" do
      expect {
        delete :destroy, params: {id: @forum_answer.to_param}, session: valid_session
      }.to change(ForumAnswer, :count).by(-1)
    end

    it "redirects to the forum_answers list" do
      delete :destroy, params: {id: @forum_answer.to_param}, session: valid_session
      expect(response).to redirect_to(forum_subject_path(@forum_answer.forum_subject))
    end
  end

end
