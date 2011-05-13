require 'ftools'

class Downloads::DlImagesController < ApplicationController
  # GET /dl_images
  # GET /dl_images.xml
  def index
    @dl_images = DlImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dl_images }
    end
  end

  # GET /dl_images/1
  # GET /dl_images/1.xml
  def show
    @dl_image = DlImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dl_image }
    end
  end

  # GET /dl_images/new
  # GET /dl_images/new.xml
  def new
    @dl_image = DlImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dl_image }
    end
  end

  # GET /dl_images/1/edit
  def edit
    @dl_image = DlImage.find(params[:id])
  end

  # POST /dl_images
  # POST /dl_images.xml
  def create
	# 将上传的参数转化为ActionDispatch::Http::UploadedFile对象
	upload_params = params[:dl_image]
	picture = upload_params[:picture]
	
	# 定义原始路径  这个路径是要替换成配置文件里的
	directory = "d:/dev/servers/xampp/htdocs/xmappimages"
	# 图片服务器根地址
	img_server_url = "http://localhost/xmappimages/"
	# 初始化日期路径
	t = Time.now
	#年月日
	year_s = t.strftime("%Y").to_s
	month_s = t.strftime("%m").to_s
	day_s = t.strftime("%d").to_s
	# 除去配置文件的路径
	file_folder = File.join(year_s, month_s, day_s)
	# 除去文件名的全路径
	base_dir = File.join(directory, file_folder)
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
	
	
	render :json => { :pic_path => img_server_url + File.join(file_folder, new_name).to_s , :name => new_name }.to_json, :content_type => 'text/xml'
	
=begin
    respond_to do |format|
      if @dl_image.save
		#render :json => { :pic_path => @dl_image.picture.url.to_s , :name => @upload.picture.instance.attributes["picture_file_name"] }, :content_type => 'text/html'
        #format.html { redirect_to(@dl_image, :notice => 'Dl image was successfully created.') }
        format.xml  { render :xml => @dl_image, :status => :created, :location => @dl_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dl_image.errors, :status => :unprocessable_entity }
      end

    end
=end
  end

  # PUT /dl_images/1
  # PUT /dl_images/1.xml
  def update
    @dl_image = DlImage.find(params[:id])

    respond_to do |format|
      if @dl_image.update_attributes(params[:dl_image])
        format.html { redirect_to(@dl_image, :notice => 'Dl image was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dl_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dl_images/1
  # DELETE /dl_images/1.xml
  def destroy
    @dl_image = DlImage.find(params[:id])
    @dl_image.destroy

    respond_to do |format|
      format.html { redirect_to(dl_images_url) }
      format.xml  { head :ok }
    end
  end
end
