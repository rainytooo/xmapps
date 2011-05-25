require 'ftools'
require 'rubygems'
require 'uuidtools'

class Downloads::DlAttachmentsController < ApplicationController
  before_filter :require_login 
  # GET /dl_attachments
  # GET /dl_attachments.xml
  def index
    @dl_attachment = DlAttachment.new
	@dl_thread = DlThread.find(params[:dl_thread_id])
	# ����ϴ��ļ���
	@max_files = MAX_ATTACHMENT_FILES
	# ��������ļ�
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
	# ����ϴ��ļ���
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
    # ���ϴ��Ĳ���ת��ΪActionDispatch::Http::UploadedFile����
	upload_params = params[:dl_attachment]
	picture = upload_params[:attachment]
	
	# ��ʼ������·��
	t = Time.now
	#������
	year_s = t.strftime("%Y").to_s
	month_s = t.strftime("%m").to_s
	day_s = t.strftime("%d").to_s
	# ��ȥ�����ļ���·��
	file_folder = File.join(year_s, month_s, day_s)
	# ��ȥ�ļ�����ȫ·��
	base_dir = File.join(FILE_UPLOAD_DIRECTORY, file_folder)
	if not File.exist?(base_dir)
	  File.makedirs(base_dir)
	end
	# ��д�ļ��� ,������Ҫ�������ļ����ȡ��·��,Ȼ��������ڴ���Ŀ¼(����Ѿ����ھͲ�����), ��uuid������
	name =  picture.original_filename
	# �ļ�����׺
	ext = File.extname(name)
	new_name = UUIDTools::UUID.timestamp_create.to_s.gsub('-','') + ext
	path = File.join(base_dir, new_name)
	File.open(path, "wb") { |f| f.write(picture.read) }
	
	# �������ļ�����Ĳ���
	@dl_thread = DlThread.find(params[:dl_thread_id])
	attachment = DlAttachment.new
	attachment.dl_thread_id = @dl_thread.id
	attachment.filename = new_name
	attachment.originname = name
	attachment.filesize = picture.size
	attachment.filepath = file_folder
	attachment.content_type = picture.content_type
	if attachment.new_record?
	  attachment.save
	end
	render :json => { :pic_path => IMG_SERVER_URL + File.join(file_folder, new_name).to_s , :size => picture.size, :name => name , :type => picture.content_type }.to_json, :content_type => 'text/html'
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
    @dl_attachment.destroy

    respond_to do |format|
      format.html { redirect_to(dl_attachments_url) }
      format.xml  { head :ok }
    end
  end
end
