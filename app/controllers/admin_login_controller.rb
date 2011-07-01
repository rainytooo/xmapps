class AdminLoginController < ApplicationController
  def index
    @login = Login.new
  end

  # POST /logins
  # POST /logins.xml
  def create
    @login = Login.new(params[:login])
    if @login.username == "xiaomaadmin" and @login.password == "1q2w3e4r"
      flash[:message] = "后台管理员登录成功,身份为小马管理员"
      session[:xiaoma_admin] = 1
      redirect_to xmadmin_index_path
      return
    elsif
      @login.username == "zhongjiaoadmin" and @login.password == "00000000"
      flash[:message] = "后台管理员登录成功,身份为中教服务管理员"
      session[:zhongjiao_admin] = 1
      redirect_to xmadmin_zjfw_path
      return
    end
    flash[:error] = "用户名密码错误,请重新输入"
    redirect_to adminlogin_path
  end
end

