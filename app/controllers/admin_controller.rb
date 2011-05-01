class AdminController < ApplicationController
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
			logger.info 'username or email is not exist'
			flash[:error] = "用户名或者邮箱不存在"
			redirect_to :action => :index
		  end
		end
		# 判断密码是否正确
		# 从uc表中取出密码
		if @dzucuser
		  if @dzucuser.password == Digest::MD5.hexdigest( Digest::MD5.hexdigest( params[:password] ) + @dzucuser.salt )
		    # 存cookie 
		    # 存session
		    logger.info 'login success'
		    # 返回首页
		  else
		    # 返回,告知密码错误
		    logger.info 'password is not correct'
			flash[:error] = "密码错误"
			redirect_to :action => :index
		  end
		end
		#logger.info @dzuser.email
	end
  end
end