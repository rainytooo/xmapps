# 个人上传管理控制器
class Manage::UploadsController < ApplicationController
  layout "downloads_layout"
  before_filter :require_login
  
  def index
	#  查询分页,我的上传
	@dl_threads = DlThread.where("user_id = ?", session[:login_user_id]).order('created_at DESC').paginate(:page=>params[:page]||1,:per_page=>10)
  end

end
