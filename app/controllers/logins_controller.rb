require 'discuz_api'
include DiscuzApi
# 登录的控制器
class LoginsController < ApplicationController
  skip_before_filter :check_cookie, :only => [:logout]
  
  def index
    @login = Login.new
	# 获取登录来源网址
	@login_from = params[:fromurl]
	
	logger.debug @login_from
  end

  def logout
	reset_session
    #if "development" == Rails.env
    #  cookies.delete(DZ_COOKIE_NAME)
    #elsif "production" == Rails.env
    #  cookies.delete(DZ_COOKIE_NAME, :domain => COOKIE_DOMAIN_NAME)
    #end
	cookies.delete(DZ_COOKIE_NAME, :domain => COOKIE_DOMAIN_NAME)
	redirect_to root_url
  end

  # POST /logins
  # POST /logins.xml
  def create
    @login = Login.new(params[:login])   	
	# 拿出返回的地址
	return_url = params[:returnurl]
	logger.debug return_url
	if request.post?
		# 这里做登录的验证
		@dzuser = Dzuser.find_by_username(@login.username)
		@dzucuser = Dzucuser.find_by_username(@login.username)
		if not @dzuser
		  # 如果不存在,再看是不是邮箱登录
		  @dzuser = Dzuser.find_by_email(@login.username)
		  @dzucuser = Dzucuser.find_by_email(@login.username)
		  if not @dzuser
		    # 如果还不存在 就返回并告知错误
			# 告知用户名或者邮箱不存在
			#logger.info 'username or email is not exist'
			flash[:error] = "用户名或者邮箱不存在"
			redirect_to :action => :index
			return
		  end
		end
		# 判断密码是否正确
		# 从uc表中取出密码
		if @dzucuser
		  if @dzucuser.password == Digest::MD5.hexdigest( Digest::MD5.hexdigest( @login.password ) + @dzucuser.salt )
			# 存cookie
			# 加密,然后算出存在cookie里的值,再写到cookie里
			auth_code = encode_cookie(DZ_AUTH_KEY, request.user_agent, @dzuser)
			logger.debug auth_code
			#cookies.permanent[DZ_COOKIE_NAME] = auth_code
			logger.debug Rails.env
			cookies[DZ_COOKIE_NAME] = {
				:value => auth_code,
				:expires => 1.year.from_now,
				:domain => COOKIE_DOMAIN_NAME
			}
			# 存session
			session[:login_user] = @dzuser
			logger.debug session[:login_user].uid
			#session[:login_user_dz] = @dzuser
			sync_local_user(@dzuser)
			# 拿出用户
			local_user = User.find_by_username(@dzuser.username)
			# 把本地用具的id存session里
			session[:login_user_id] = local_user.id
			# 返回首页
			flash[:message] = "登录成功"
			# 返回登录前的页面
			if return_url
				redirect_to return_url
			else
				redirect_to :root
			end
		  else
		      # 返回,告知密码错误
		      #logger.info 'password is not correct'
			  flash[:error] = "密码错误"
			  redirect_to :action => :index
		    end
		  end
		  #logger.info @dzuser.email
	  end
  end
end


