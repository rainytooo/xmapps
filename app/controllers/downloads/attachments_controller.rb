
#require "prawn"
class Downloads::AttachmentsController < ApplicationController
  before_filter :require_login 
  # 显示验证码
  def show
	@dl_attachment = DlAttachment.find(params[:id])
	# 我当前的积分和金币
	# 拿出用户金币
	dz_user = Dzuser.find_by_username(session[:login_user].username)
	@extcredits = DzCommonMemberCount.find_by_uid(dz_user.uid)
  end
  # 下载的方法
  def create
	# 获取文件
	if simple_captcha_valid?
		@dl_attachment = DlAttachment.find(params[:attachment_id])
		# 获取文件路径
		file_full_path = FILE_UPLOAD_DIRECTORY + "/"+ @dl_attachment.filepath + "/" + @dl_attachment.filename
		# 拿出用户金币
		dz_user = Dzuser.find_by_username(session[:login_user].username)
		extcredits6 = DzCommonMemberCount.find_by_uid(dz_user.uid)
		if (extcredits6.extcredits6.to_i - 5) < 0
			flash[:error] = "对不起!您的金币数量不足以下载此资源,下载此资源至少需要5个金币,您只有" + extcredits6.extcredits6.to_s
			redirect_to downloads_attachment_path(params[:attachment_id])
		else 
			# 输出流
			send_file(file_full_path, :filename => @dl_attachment.originname)
						#:type: => @dl_attachment.content_type  )
			# 更新下载次数
			ActiveRecord::Base.connection.update("update dl_attachments set donwloads = donwloads+1 where id = " + params[:attachment_id])
			extcredits6.update_attribute(:extcredits6, extcredits6.extcredits6.to_i - 5)
		end
	else
		flash[:error] = "验证码不正确,请重新输入"
		redirect_to downloads_attachment_path(params[:attachment_id])
	end			
  end
end
