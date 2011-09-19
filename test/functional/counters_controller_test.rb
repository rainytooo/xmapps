require 'test_helper'

class CountersControllerTest < ActionController::TestCase
  setup do
    @counter = counters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:counters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create counter" do
    assert_difference('Counter.count') do
      post :create, :counter => @counter.attributes
    end

    assert_redirected_to counter_path(assigns(:counter))
  end

  test "should show counter" do
    get :show, :id => @counter.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @counter.to_param
    assert_response :success
  end

  test "should update counter" do
    put :update, :id => @counter.to_param, :counter => @counter.attributes
    assert_redirected_to counter_path(assigns(:counter))
  end

  test "should destroy counter" do
    assert_difference('Counter.count', -1) do
      delete :destroy, :id => @counter.to_param
    end

    assert_redirected_to counters_path
  end
end
