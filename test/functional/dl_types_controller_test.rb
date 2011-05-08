require 'test_helper'

class DlTypesControllerTest < ActionController::TestCase
  setup do
    @dl_type = dl_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dl_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dl_type" do
    assert_difference('DlType.count') do
      post :create, :dl_type => @dl_type.attributes
    end

    assert_redirected_to dl_type_path(assigns(:dl_type))
  end

  test "should show dl_type" do
    get :show, :id => @dl_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @dl_type.to_param
    assert_response :success
  end

  test "should update dl_type" do
    put :update, :id => @dl_type.to_param, :dl_type => @dl_type.attributes
    assert_redirected_to dl_type_path(assigns(:dl_type))
  end

  test "should destroy dl_type" do
    assert_difference('DlType.count', -1) do
      delete :destroy, :id => @dl_type.to_param
    end

    assert_redirected_to dl_types_path
  end
end
