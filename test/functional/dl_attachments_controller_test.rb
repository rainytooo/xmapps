require 'test_helper'

class DlAttachmentsControllerTest < ActionController::TestCase
  setup do
    @dl_attachment = dl_attachments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dl_attachments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dl_attachment" do
    assert_difference('DlAttachment.count') do
      post :create, :dl_attachment => @dl_attachment.attributes
    end

    assert_redirected_to dl_attachment_path(assigns(:dl_attachment))
  end

  test "should show dl_attachment" do
    get :show, :id => @dl_attachment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @dl_attachment.to_param
    assert_response :success
  end

  test "should update dl_attachment" do
    put :update, :id => @dl_attachment.to_param, :dl_attachment => @dl_attachment.attributes
    assert_redirected_to dl_attachment_path(assigns(:dl_attachment))
  end

  test "should destroy dl_attachment" do
    assert_difference('DlAttachment.count', -1) do
      delete :destroy, :id => @dl_attachment.to_param
    end

    assert_redirected_to dl_attachments_path
  end
end
