require 'test_helper'

class AskAnswersControllerTest < ActionController::TestCase
  setup do
    @ask_answer = ask_answers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ask_answers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ask_answer" do
    assert_difference('AskAnswer.count') do
      post :create, :ask_answer => @ask_answer.attributes
    end

    assert_redirected_to ask_answer_path(assigns(:ask_answer))
  end

  test "should show ask_answer" do
    get :show, :id => @ask_answer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ask_answer.to_param
    assert_response :success
  end

  test "should update ask_answer" do
    put :update, :id => @ask_answer.to_param, :ask_answer => @ask_answer.attributes
    assert_redirected_to ask_answer_path(assigns(:ask_answer))
  end

  test "should destroy ask_answer" do
    assert_difference('AskAnswer.count', -1) do
      delete :destroy, :id => @ask_answer.to_param
    end

    assert_redirected_to ask_answers_path
  end
end
