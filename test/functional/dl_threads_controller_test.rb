require 'test_helper'

class DlThreadsControllerTest < ActionController::TestCase
  setup do
    @dl_thread = dl_threads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dl_threads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dl_thread" do
    assert_difference('DlThread.count') do
      post :create, :dl_thread => @dl_thread.attributes
    end

    assert_redirected_to dl_thread_path(assigns(:dl_thread))
  end

  test "should show dl_thread" do
    get :show, :id => @dl_thread.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @dl_thread.to_param
    assert_response :success
  end

  test "should update dl_thread" do
    put :update, :id => @dl_thread.to_param, :dl_thread => @dl_thread.attributes
    assert_redirected_to dl_thread_path(assigns(:dl_thread))
  end

  test "should destroy dl_thread" do
    assert_difference('DlThread.count', -1) do
      delete :destroy, :id => @dl_thread.to_param
    end

    assert_redirected_to dl_threads_path
  end
end
