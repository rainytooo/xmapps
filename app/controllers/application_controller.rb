require 'discuz_api'
include DiscuzApi
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  # 验证码
  include SimpleCaptcha::ControllerHelpers
  protect_from_forgery
  # 过滤器定义
  before_filter :check_cookie
  
  # 下面是过滤器的定义部分
  private
  def record_not_found
    render '/404.html'
  end
  # 给discuz 用户发提醒
  def send_dz_notify(dz_user_id, authorid, author, message, from_idtype)
	sql = """
	insert into #{DZ_TABLE_PRE}home_notification (uid,type,new,authorid,author,note,dateline,from_id,from_idtype,from_num) VALUES
	(
		#{dz_user_id}, 'upload_pass', 1, #{authorid}, '#{author}', '#{message}', #{Time.now.to_i}, 0, '#{from_idtype}', 1
	)
	"""
	sql2 = """
	update #{DZ_TABLE_PRE}common_member_status SET notifications=notifications+1 WHERE uid=#{dz_user_id}
	"""
	sql3 = """
	update #{DZ_TABLE_PRE}common_member SET newprompt=newprompt+1 WHERE uid=#{dz_user_id}
	"""
	Dzxdb.connection.insert(sql)
	Dzxdb.connection.update(sql2)
	Dzxdb.connection.update(sql3)
  end
  # 添加discuz动态
  def send_dz_feed(appid, dz_user_id, dz_user_name, title_template, title_data, body_template, body_data)
	sql = """
	INSERT INTO #{DZ_TABLE_PRE}home_feed SET appid=#{appid}, icon='sitefeed', uid=#{dz_user_id}, username='#{dz_user_name}',
			title_template='#{title_template}', title_data='#{title_data}', body_template='#{body_template}', body_data='#{$body_data}',
			dateline=#{Time.now.to_i}, body_general='', target_ids=''
	"""
	Dzxdb.connection.insert(sql)
  end
  
  # 加discuz积分
  def add_discuz_credits(dz_user_id, counts)
	Dzxdb.connection.insert("update #{DZ_TABLE_PRE}common_member_count set extcredits8 = extcredits8 + #{counts} where uid = #{dz_user_id}")
  end
  # 加金币
  def add_discuz_extcredits(dz_user_id, counts)
	Dzxdb.connection.insert("update #{DZ_TABLE_PRE}common_member_count set extcredits6 = extcredits6 + #{counts} where uid = #{dz_user_id}")
  end
  
  # 检查cookie里是否已经登录,从discuz登录的就自动登录一下
  def check_cookie

	# 如果session已经记录了登录信息,说明已经登录过了
	if not session[:login_user]
	# 如果没有session
	  # 检查cookie 如果存在
	  if cookies[DZ_COOKIE_NAME]
		# 解码cookie
		passwd_uid = decode_cookie(DZ_AUTH_KEY, request.user_agent, cookies, DZ_COOKIE_NAME)
		# 如果解不出来 就把这个cookie删除了
		if passwd_uid == nil
			reset_session
			cookies.delete(DZ_COOKIE_NAME, :domain => COOKIE_DOMAIN_NAME)
			return
		end 
		dzuser = Dzuser.find_by_uid(passwd_uid[1])
		dzucuser = Dzucuser.find_by_uid(passwd_uid[1])
		# 如果id和密码匹配
		if dzuser.password == passwd_uid[0]
		  # 存session
		  session[:login_user] = dzuser	
		  sync_local_user(dzuser)
		  # 拿出用户
		  local_user = User.find_by_username(dzuser.username)
		  # 把本地用具的id存session里
		  session[:login_user_id] = local_user.id
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
  
  # 检查此资源是否自己可以访问
  def check_self_manage
	unless is_not_mine?
      flash[:error] = "你没有权限查看此资源,请用相应身份登录"
      redirect_to login_url # halts request cycle
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
	  local_user.dz_common_id = user.uid
	  if local_user.new_record?
		local_user.save
		# 创建一个计数器记录
		user_count = UserCount.new
		user_count.user_id = local_user.id
		user_count.save
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
  
  # 检查是不是用户的
  def is_not_mine?
	if session[:login_user].id == params[id]
	  return false
	else
	  return true
	end
  end
  
end
