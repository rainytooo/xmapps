require 'test_helper'

class ValidateImagesControllerTest < ActionController::TestCase
  setup do
    @validate_image = validate_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:validate_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create validate_image" do
    assert_difference('ValidateImage.count') do
      post :create, :validate_image => @validate_image.attributes
    end

    assert_redirected_to validate_image_path(assigns(:validate_image))
  end

  test "should show validate_image" do
    get :show, :id => @validate_image.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @validate_image.to_param
    assert_response :success
  end

  test "should update validate_image" do
    put :update, :id => @validate_image.to_param, :validate_image => @validate_image.attributes
    assert_redirected_to validate_image_path(assigns(:validate_image))
  end

  test "should destroy validate_image" do
    assert_difference('ValidateImage.count', -1) do
      delete :destroy, :id => @validate_image.to_param
    end

    assert_redirected_to validate_images_path
  end
end
