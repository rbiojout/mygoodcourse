require 'test_helper'

#http://jeffkreeftmeijer.com/2014/using-test-fixtures-with-carrierwave/

class AttachmentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @attachment = attachments(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end


  test "should not exceed size" do

  end

  test "should respect filetype" do

  end

  test "should build different formats" do

  end

  test "should download" do
    @attachment.file = fixture_file_upload('/files/Sommaire.pdf', 'application/pdf')
    @attachment.save!

    get :download, id: @attachment
    assert @attachment.product.candownload(customers(:one))
    assert_response :success
  end

  test "need signed user" do
    @attachment.file = fixture_file_upload('/files/Sommaire.pdf', 'application/pdf')
    @attachment.save!

    sign_out(customers(:one))

    get :download, id: @attachment
    assert_redirected_to new_customer_session_path
  end

  test "need correct user" do
    @attachment.file = fixture_file_upload('/files/Sommaire.pdf', 'application/pdf')
    @attachment.save!

    sign_out(customers(:one))
    sign_in(customers(:two), scope: :customer)

    get :download, id: @attachment
    assert_redirected_to catalog_products_path
  end

end
