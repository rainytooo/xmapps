class Downloads::Admin::ThreadsController < ApplicationController
  before_filter :require_login , :require_admin
  # GET /dl_threads
  # GET /dl_threads.xml
  def index
    #  查询分页,管理所有上传
	@dl_threads = DlThread.order('created_at DESC').paginate(:page=>params[:page]||1,:per_page=>10)
	
	logger.info @dl_threads.size
  end



  # PUT /dl_threads/1
  # PUT /dl_threads/1.xml
  # 审核
  def update
    @dl_thread = DlThread.find(params[:id])
	if @dl_thread.ispass == 0
	  @dl_thread.update_attribute(:ispass, 1)
	  thread_url = dl_url(@dl_thread.id)
	  message = "您上传的资源<a href=\"#{thread_url}\" >#{@dl_thread.name}<\/a>已经通过了审核"
	  logger.info 
	  # 查出发表用户的 discuz 中的user对象
	  # 审核人的discuz uid
	  pass_user = session[:login_user]
          upload_user = User.find_by_id(@dl_thread.user_id)
	  dz_user = Dzuser.find_by_username(upload_user.username)
	  # 发送提醒
	  send_dz_notify @dl_thread.user_id, pass_user.uid, '', message, 'uploads'
	  # 发送全站动态
	  title_template = "#{dz_user.username}在<a href=\"#{dl_index_url}\" >资源下载<\/a>上传了新的资料<a href=\"#{thread_url}\" >#{@dl_thread.name}<\/a>"
	  title_data = {}
	  require 'php_serialization'
	  title_data = PhpSerialization.dump(title_data)
	  send_dz_feed 2001, dz_user.uid, dz_user.username, title_template, title_data, '', title_data
	  # 加积分
	  add_discuz_credits dz_user.uid, DZ_CREDITS_ADD_COUNT
	  add_discuz_extcredits dz_user.uid, DZ_EXTCREDITS_ADD_COUNT
	else
	  @dl_thread.update_attribute(:ispass, 0)
	  dz_user = Dzuser.find_by_uid(@dl_thread.user_id)
	  add_discuz_credits dz_user.uid, DZ_CREDITS_REDUCE_COUNT
	  add_discuz_extcredits dz_user.uid, DZ_EXTCREDITS_REDUCE_COUNT
	end
	# 更新用户的 上传的次数
	total_pass_count = DlThread.where("user_id = ? and ispass = 1", @dl_thread.user_id).count
	ActiveRecord::Base.connection.update("update user_counts set uploads = " + total_pass_count.to_s + " where user_id = " + @dl_thread.user_id.to_s)
	redirect_to downloads_admin_threads_path
  end

end
