require 'discuz_api'

class AdminController < ApplicationController
  include DiscuzApi
  def index
	
  end
  
  def login
    if request.post?
		# 这里做登录的验证
		@dzuser = Dzuser.find_by_username(params[:username])
		@dzucuser = Dzucuser.find_by_username(params[:username])
		if not @dzuser
		# 如果不存在,再看是不是邮箱登录
		  @dzuser = Dzuser.find_by_email(params[:username])
		  @dzucuser = Dzucuser.find_by_email(params[:username])
		  if not @dzuser
		    # 如果还不存在 就返回并告知错误
			# 告知用户名或者邮箱不存在
			#logger.info 'username or email is not exist'
			flash[:error] = "用户名或者邮箱不存在"
			redirect_to :action => :index
		  end
		end
		# 判断密码是否正确
		# 从uc表中取出密码
		if @dzucuser
		  if @dzucuser.password == Digest::MD5.hexdigest( Digest::MD5.hexdigest( params[:password] ) + @dzucuser.salt )
		    # 存cookie 
			# 加密,然后算出存在cookie里的值,再写到cookie里
			auth_code = encode_cookie(Rails.configuration.dz_auth_key, request.user_agent, @dzuser)
			cookies.permanent[Rails.configuration.dz_cookie_name] = auth_code
			#cookies.[Rails.configuration.dz_cookie_name] = { 
			#	:value => auth_code, 
			#	:expires => 1.hour.from_now,
			#	:domain => 'localhost'			
			#	}
		    # 存session
			session[:login_user] = @dzuser		
		    #logger.info 'login success'
		    # 返回首页
			flash[:message] = "登录成功"
			redirect_to :root
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
  
  # communication  with uc server function
  def ucapi
	# define the UC_KEY
	uc_key = '123123123'
	# get the parmeters pass from the uc server ,the request is localhost:3000/uc.php
	code = params[:code]
	logger.info code
	# decode the code  , for example , it will get 'action=test&time=1304570967'
	parse_code = authcode(code,true,uc_key)
	logger.info parse_code
	# get the action and time value
	act_time = parse_code.split('&')
	action_v = act_time[0]
	time_v = act_time[1]
	action_value = action_v[action_v.index('=') + 1,action_v.length]
	time_value = time_v[time_v.index('=') + 1,time_v.length]
	logger.info "action:" + action_value + ", time:" + time_value
	
	if action_value == 'test'
	  logger.info 'test success'
	  render :text => '1'
	end
  end
end