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
    #@dl_image = DlImage.new(params[:dl_image])
	logger.info "888888888888888888888888888888888888888888888888888"
	upload_params = params[:dl_image]
	picture = upload_params[:picture]
	name =  picture.original_filename
	directory = "public/data"
	path = File.join(directory, name)
	File.open(path, "wb") { |f| f.write(picture.read) }
	
	
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
