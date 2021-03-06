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

RSpec.describe CyclesController, type: :controller do

  # even if not recommended, we test the rendering in the controller
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Cycle. As you add validations to Cycle, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CyclesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all cycles as @cycles" do
      get :index, params: {}, session: valid_session
      expect(assigns(:cycles)).not_to be_nil
    end
  end

  describe "GET #show" do
    it "assigns the requested cycle as @cycle" do
      cycle = cycles(:one)
      get :show, params: {id: cycle}, session: valid_session
      expect(assigns(:cycle)).to eq(cycle)
    end
  end

end
