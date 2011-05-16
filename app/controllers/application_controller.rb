require 'discuz_api'
include DiscuzApi
class ApplicationController < ActionController::Base
  protect_from_forgery
  # 过滤器定义
  before_filter :check_cookie
  
  # 下面是过滤器的定义部分
  private
  
  # 检查cookie里是否已经登录,从discuz登录的就自动登录一下
  def check_cookie
	# 如果session已经记录了登录信息,说明已经登录过了
	if not session[:login_user]
	# 如果没有session
	  # 检查cookie 如果存在
	  if cookies[DZ_COOKIE_NAME]
		# 解码cookie
		passwd_uid = decode_cookie(DZ_AUTH_KEY, request.user_agent, cookies, DZ_COOKIE_NAME)
		dzuser = Dzuser.find_by_uid(passwd_uid[1])
		dzucuser = Dzucuser.find_by_uid(passwd_uid[1])
		# 如果id和密码匹配
		if dzuser.password == passwd_uid[0]
		  # 存session
		  session[:login_user] = dzuser	
		  sync_local_user(dzuser)
		end
	  end	
	else 
	  # 如果session里有,cookie里没有,说明discuz那边已经退出了
	  if not cookies[DZ_COOKIE_NAME]
		reset_session
		cookies.delete(DZ_COOKIE_NAME)
	  end
	end  
  end
  
  # 同步本地用户
  def sync_local_user(user)
  # 判断用户在表里是否存在
	local_user = User.find_by_email(user.email)
	if not local_user
	  # 不存在就创建一个
	  local_user = User.new
	  local_user.email = user.email
	  local_user.username = user.username
	  local_user.passwd = user.password
	  local_user.regdate = user.regdate
	  if local_user.new_record?
		local_user.save
	  end
	end
  end
  
 
  def require_login
    unless logged_in?
      flash[:error] = "必须登录才能继续刚才的操作,请登录"
      redirect_to login_url # halts request cycle
    end
  end
 
  def logged_in?
    !!session[:login_user]
  end
  
  def require_admin
	unless logged_admin?
      flash[:error] = "你必须具有管理员权限,请用管理员身份登录"
      redirect_to login_url # halts request cycle
	end
  end
  
  def logged_admin?
	if session[:login_user].id == 1
	  return true
	else
	  return false
	end
  end
end
