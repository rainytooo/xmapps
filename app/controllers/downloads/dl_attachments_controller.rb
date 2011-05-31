require 'ftools'
require 'rubygems'
require 'uuidtools'

include ActionView::Helpers::NumberHelper
class Downloads::DlAttachmentsController < ApplicationController
  before_filter :require_login 
  # GET /dl_attachments
  # GET /dl_attachments.xml
  def index
    @dl_attachment = DlAttachment.new
	@dl_thread = DlThread.find(params[:dl_thread_id])
	# 最多上传文件数
	@max_files = MAX_ATTACHMENT_FILES
	# 查出所有文件
	@dl_attachments = DlAttachment.where("dl_thread_id = ?", @dl_thread.id)
  end

  # GET /dl_attachments/1
  # GET /dl_attachments/1.xml
  def show
    @dl_attachment = DlAttachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dl_attachment }
    end
  end

  # GET /dl_attachments/new
  # GET /dl_attachments/new.xml
  def new
    @dl_attachment = DlAttachment.new
	@dl_thread = DlThread.find(params[:dl_thread_id])
	# 最多上传文件数
	@max_files = MAX_ATTACHMENT_FILES
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dl_attachment }
    end
  end

  # GET /dl_attachments/1/edit
  def edit
    @dl_attachment = DlAttachment.find(params[:id])
  end

  # POST /dl_attachments
  # POST /dl_attachments.xml
  def create
    # 将上传的参数转化为ActionDispatch::Http::UploadedFile对象
	upload_params = params[:dl_attachment]
	picture = upload_params[:attachment]
	
	# 初始化日期路径
	t = Time.now
	#年月日
	year_s = t.strftime("%Y").to_s
	month_s = t.strftime("%m").to_s
	day_s = t.strftime("%d").to_s
	# 除去配置文件的路径
	file_folder = File.join(year_s, month_s, day_s)
	# 除去文件名的全路径
	base_dir = File.join(FILE_UPLOAD_DIRECTORY, file_folder)
	if not File.exist?(base_dir)
	  File.makedirs(base_dir)
	end
	# 重写文件名 ,这里需要从配置文件里读取根路径,然后根据日期创建目录(如果已经存在就不创建), 用uuid重命名
	name =  picture.original_filename
	# 文件名后缀
	ext = File.extname(name)
	new_name = UUIDTools::UUID.timestamp_create.to_s.gsub('-','') + ext
	path = File.join(base_dir, new_name)
	File.open(path, "wb") { |f| f.write(picture.read) }
	
	# 下面是文件保存的部分
	@dl_thread = DlThread.find(params[:dl_thread_id])
	attachment = DlAttachment.new
	attachment.dl_thread_id = @dl_thread.id
	attachment.filename = new_name
	attachment.originname = name
	attachment.filesize = picture.size
	attachment.filepath = file_folder
	attachment.content_type = picture.content_type
	file_size = number_to_human_size(picture.size, :locale => :en)
	if attachment.new_record?
	  attachment.save
	end
	render :json => { :pic_path => IMG_SERVER_URL + File.join(file_folder, new_name).to_s , :size => file_size, :name => name , :type => picture.content_type }.to_json, :content_type => 'text/html'
  end

  # PUT /dl_attachments/1
  # PUT /dl_attachments/1.xml
  def update
    @dl_attachment = DlAttachment.find(params[:id])

    respond_to do |format|
      if @dl_attachment.update_attributes(params[:dl_attachment])
        format.html { redirect_to(@dl_attachment, :notice => 'Dl attachment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dl_attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dl_attachments/1
  # DELETE /dl_attachments/1.xml
  def destroy
	
    @dl_attachment = DlAttachment.find(params[:id])
	@dl_thread = DlThread.find_by_id(@dl_attachment.dl_thread_id)
	if @dl_thread.user_id == session[:login_user_id]
		@dl_attachment.destroy
	else
		flash[:error] = "对不起!您无权进行此操作"
	end
	redirect_to downloads_dl_thread_dl_attachments_path(@dl_thread)
  end
end
