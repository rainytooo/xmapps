require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  # ·�ɵĲ���
  test "should route to index" do
	assert_routing '/', { :controller => "home", :action => "index"}
  end
end
