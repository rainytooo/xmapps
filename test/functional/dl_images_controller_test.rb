require 'test_helper'

class DlImagesControllerTest < ActionController::TestCase
  setup do
    @dl_image = dl_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dl_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dl_image" do
    assert_difference('DlImage.count') do
      post :create, :dl_image => @dl_image.attributes
    end

    assert_redirected_to dl_image_path(assigns(:dl_image))
  end

  test "should show dl_image" do
    get :show, :id => @dl_image.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @dl_image.to_param
    assert_response :success
  end

  test "should update dl_image" do
    put :update, :id => @dl_image.to_param, :dl_image => @dl_image.attributes
    assert_redirected_to dl_image_path(assigns(:dl_image))
  end

  test "should destroy dl_image" do
    assert_difference('DlImage.count', -1) do
      delete :destroy, :id => @dl_image.to_param
    end

    assert_redirected_to dl_images_path
  end
end
