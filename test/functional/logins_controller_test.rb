require 'test_helper'
# 登录的单元测试
class LoginsControllerTest < ActionController::TestCase
  setup do
    @login = logins(:admin)
	@login_with_mail = logins(:admin_with_mail)
	@login_pass_error = logins(:admin_pass_error)
	@login_username_error = logins(:admin_username_error)
  end
  
  teardown do
	@login = nil
	@login_with_mail = nil
	@login_pass_error = nil
	@login_username_error = nil
  end
  
  # 登录页面测试 展示测试
  test "should get login" do
    get :index
	# 成功打开登录页
    assert_response :success	
  end

  # 登录提交页面测试 测试登录成功
  test "should login success" do
	# 测试用户不存在
	# 测试密码错误
	# 测试cookie是否存在
	# 测试同步登录了  
    post :create, :login => @login.attributes
    assert_redirected_to root_path
	# 登录成功信息
	assert_equal "登录成功", flash[:message]
	# session保存了值
    assert_not_nil session[:login_user]
	# cookie 保存了值
	assert_not_nil cookies[DZ_COOKIE_NAME]
  end
  
  # 登录提交页面测试 测试登录成功 用email 登录
  test "should login success with mail" do
	# 测试用户不存在
	# 测试密码错误
	# 测试cookie是否存在
	# 测试同步登录了  
    post :create, :login => @login_with_mail.attributes
    assert_redirected_to root_path
	# 登录成功信息
	assert_equal "登录成功", flash[:message]
	# session保存了值
    assert_not_nil session[:login_user]
	# cookie 保存了值
	assert_not_nil cookies[DZ_COOKIE_NAME]
  end
  
  # 登录提交页面测试 测试密码错误
  test "login with incorrect password" do
    post :create, :login => @login_pass_error.attributes
    assert_redirected_to login_path
	# 测试提示信息 密码错误
	assert_equal "密码错误", flash[:error]  
  end
  
  # 登录提交页面测试 测试用户名不存在
  test "login with user not exist" do
    post :create, :login => @login_username_error.attributes
    assert_redirected_to login_path
	# 测试提示信息 密码错误
	assert_equal "用户名或者邮箱不存在", flash[:error]  
  end

end
