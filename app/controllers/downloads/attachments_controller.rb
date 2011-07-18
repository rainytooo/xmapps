require 'iconv'
require 'uri'
#require "prawn"
class Downloads::AttachmentsController < ApplicationController
  before_filter :require_login_to_main_server
  # 显示验证码
  def show
	@dl_attachment = DlAttachment.find(params[:id])
	@dl_thread = DlThread.find_by_id(@dl_attachment.dl_thread_id )
	if 	@dl_thread.ispass == 0
		render '/404.html'
		return
	end
	# 我当前的积分和金币
	# 拿出用户金币
	dz_user =session[:login_user]
	@extcredits = DzCommonMemberCount.find_by_uid(dz_user.uid)
  end
  # 下载的方法
  def create
	# 获取文件
	if simple_captcha_valid?
		@dl_attachment = DlAttachment.find(params[:attachment_id])
		# 获取文件路径
		file_full_path = FILE_UPLOAD_DIRECTORY + "/"+ @dl_attachment.filepath + "/" + @dl_attachment.filename
		dl_thread = DlThread.find_by_id(@dl_attachment.dl_thread_id)
		# 拿出用户金币
		dz_user = session[:login_user]
		# 消耗的金币数量
    cost_gold = dl_thread.gold
		extcredits6 = DzCommonMemberCount.find_by_uid(dz_user.uid)
		# 如果用户积分少于30 不能下载
		if dz_user.credits.to_i < 30
		  flash[:error] = "小马留学是免费网站,所以没有收取会员任何费用,由于服务器带宽有限,同时下载的人数太多,为了保证下载质量,所以下载资源需要有一定的积分,您的积分太低不足以下载此资源,下载此资源至少需要30的积分,您只有" + dz_user.credits.to_s
			redirect_to downloads_attachment_path(params[:attachment_id])
    end
		if (extcredits6.extcredits6.to_i - cost_gold) < 0
			flash[:error] = "小马留学是免费网站,所以没有收取会员任何费用,由于服务器带宽有限,同时下载的人数太多,为了保证下载质量,所以下载资源需要扣除金币,下载此资源至少需要#{cost_gold}个金币,您只有" + extcredits6.extcredits6.to_s
			redirect_to downloads_attachment_path(params[:attachment_id])
		else
			# 输出流
			# 识别浏览器 来修改文件名 针对IE对文件名编码
			origin_filename = @dl_attachment.originname
			user_agent = request.env['HTTP_USER_AGENT'].downcase
			if user_agent.include? "msie"
			  origin_filename = URI.escape origin_filename
			end
			#new_filename = request.env['HTTP_USER_AGENT'].match('MSIE')  ? Iconv.conv('gb2312','utf-8', origin_filename) : origin_filename
			send_file(file_full_path, :filename => origin_filename)
			# 更新下载次数
			ActiveRecord::Base.connection.update("update dl_attachments set donwloads = donwloads+1 where id = " + params[:attachment_id])
			# 扣金币
			# 先查有没有扣过分
			dl_record = DlRecord.where("user_id = :user_id and 	thread_id = :thread_id", {:user_id => session[:login_user_id], :thread_id => @dl_attachment.dl_thread_id })
			if dl_record.empty?
				extcredits6.update_attribute(:extcredits6, extcredits6.extcredits6.to_i - cost_gold)
				dl_record = DlRecord.new
				dl_record.user_id = session[:login_user_id]
				dl_record.thread_id = @dl_attachment.dl_thread_id
				dl_record.extcredits = cost_gold
				dl_record.save
				# 给用户加金币
				#add_discuz_extcredits dl_thread.user.dz_common_id, cost_gold
			end
		end
	else
		flash[:error] = "验证码不正确,请重新输入"
		redirect_to downloads_attachment_path(params[:attachment_id])
	end
  end

  private

  def require_login_to_main_server
    unless logged_in?
      flash[:error] = "必须登录才能继续刚才的操作,请登录"
      redirect_to XMAPP_MAIN_DOMAIN_URL + "/login" # halts request cycle
    end
  end

  def logged_in?
    !!session[:login_user]
  end
end

