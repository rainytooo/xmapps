require 'test_helper'

class AppliesControllerTest < ActionController::TestCase
  setup do
    @apply = applies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apply" do
    assert_difference('Apply.count') do
      post :create, :apply => @apply.attributes
    end

    assert_redirected_to apply_path(assigns(:apply))
  end

  test "should show apply" do
    get :show, :id => @apply.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @apply.to_param
    assert_response :success
  end

  test "should update apply" do
    put :update, :id => @apply.to_param, :apply => @apply.attributes
    assert_redirected_to apply_path(assigns(:apply))
  end

  test "should destroy apply" do
    assert_difference('Apply.count', -1) do
      delete :destroy, :id => @apply.to_param
    end

    assert_redirected_to applies_path
  end
end
