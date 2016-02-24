require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  setup do
    @attachment = attachments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attachments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attachment" do
    assert_difference('Attachment.count') do
      post :create, attachment: { active: @attachment.active, file: @attachment.file, file_name: @attachment.file_name, file_size: @attachment.file_size, file_type: @attachment.file_type, nbpages: @attachment.nbpages, preview: @attachment.preview, product_id: @attachment.product_id, version_number: @attachment.version_number }
    end

    assert_redirected_to attachment_path(assigns(:attachment))
  end

  test "should show attachment" do
    get :show, id: @attachment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @attachment
    assert_response :success
  end

  test "should update attachment" do
    patch :update, id: @attachment, attachment: { active: @attachment.active, file: @attachment.file, file_name: @attachment.file_name, file_size: @attachment.file_size, file_type: @attachment.file_type, nbpages: @attachment.nbpages, preview: @attachment.preview, product_id: @attachment.product_id, version_number: @attachment.version_number }
    assert_redirected_to attachment_path(assigns(:attachment))
  end

  test "should destroy attachment" do
    assert_difference('Attachment.count', -1) do
      delete :destroy, id: @attachment
    end

    assert_redirected_to attachments_path
  end
end
