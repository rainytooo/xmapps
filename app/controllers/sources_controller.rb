require 'uri'
require 'ftools'
require 'rubygems'
require 'uuidtools'

require 'RMagick'
include Magick
class SourcesController < ApplicationController
  before_filter :require_login , :except => [:index, :show, :untrans, :search, :release]
  before_filter :require_operation_check , :only => [:create]
  # GET /sources
  # GET /sources.xml
  def index
    # 最新发布的
    @sources = Source.where("status != 0").order("created_at DESC").limit(20)
    # 最新翻译的
    @translations = Translation.order("created_at DESC").limit(20)
    @untrans_sources = Source.where("status = 1").order("created_at DESC").limit(20)
    # 排行榜
    @trans_rank = TranRank.where("campaign = 'all' and total_excredits > 0").order("total_excredits DESC").limit(30)
  end
  # 新发布的
  def release
    @sources = Source.where("status != 0").order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
  end
  # 未翻译的
  def untrans
    @sources = Source.where("status = 1").order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
  end

  # 翻译的
  def trans
    @translations = Translation.order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
  end

  # 翻译大赛


  #搜索
  def search
    if params[:tags] and !params[:lang]
      @sources = @sources = Source.where("status != 0 and source_type_id = #{params[:tags]}").order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
    elsif params[:lang] and !params[:tags]
      @sources = @sources = Source.where("status != 0 and source_lang_id = #{params[:lang]}").order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
    elsif params[:type] = "source"
		  @search_string = params[:query]
		  @search_string.strip
		  @search_string.squeeze!("\s")
		  @search_string = '%'+@search_string+'%'
		  @sources = Source.where("title like :search_string or content like :search_string",
          {:search_string => @search_string}).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
    end
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    @source = Source.find(params[:id])
    # 查出所有提交的翻译
    @translations = Translation.where("source_id = ?", @source.id)
    ActiveRecord::Base.connection.update("update sources set views = views+1 where id = " + @source.id.to_s)
  end

  # GET /sources/new
  # GET /sources/new.xml
  def new
    @source = Source.new

  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
    if @source.user_id == session[:login_user_id] or logged_admin? or logged_xm_admin?
      logger.debug 'edit source ' + @source.id.to_s
    else
      flash.now[:error] = "对不起,您无权进行此操作"
		  render '/errors_messages.html'
    end
  end
  # 我的译文
  def my
     #我发布的
     @my_release = Source.where("user_id = ?" , session[:login_user_id]).order("created_at DESC").limit(10)
     #我翻译的
     @my_trans = Translation.where("user_id = ?" , session[:login_user_id]).order("created_at DESC").limit(10)

  end
  # 我发布的
  def my_release
     #我发布的
     @my_release = Source.where("user_id = ?" , session[:login_user_id]).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
  end
  # 我翻译的
  def my_trans
     #我翻译的
     @my_trans = Translation.where("user_id = ?" , session[:login_user_id]).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
  end

  # POST /sources
  # POST /sources.xml
  def create
    @source = Source.new(params[:source])
    @source.user_id = session[:login_user_id]
    @source.dz_user_id = session[:login_user].uid
    @source.username = session[:login_user].username
    @source.source_type_id = params[:source_type]
    @source.source_lang_id = params[:source_lang]
    @source.excredits = params[:excredits].to_i
    if @source.save
      source_photo = params[:photo]
      # 如果有缩略图
      if source_photo
        logger.debug 'source has photo'
        # 创建路径
		    # 初始化日期路径
		    #年月日
		    year_s = @source.created_at.year.to_s
		    month_s = @source.created_at.month.to_s
		    day_s = @source.created_at.day.to_s
		    # 除去配置文件的路径
		    file_folder = File.join("photos",year_s, month_s, day_s,@source.id.to_s)
		    source_photo_path = DOWNLOAD_THREAD_PHOTO_ROOT_PATH + "/sources"
		    base_dir = File.join(source_photo_path, file_folder)
		    base_dir_medium = File.join(source_photo_path, file_folder, "medium")
		    base_dir_original = File.join(source_photo_path, file_folder, "original")
		    base_dir_thumb = File.join(source_photo_path, file_folder, "thumb")
		    if not File.exist?(base_dir)
			    File.makedirs(base_dir_medium)
			    File.makedirs(base_dir_original)
			    File.makedirs(base_dir_thumb)
		    end
		    # 重写文件名 ,这里需要从配置文件里读取根路径,然后根据日期创建目录(如果已经存在就不创建), 用uuid重命名
		    name =  source_photo.original_filename
		    # 文件名后缀
		    ext = File.extname(name)
		    new_name = UUIDTools::UUID.timestamp_create.to_s.gsub('-','') + ext
		    path = File.join(base_dir_original, new_name)
		    medium_path = File.join(base_dir_medium, new_name)
		    thumb_path = File.join(base_dir_thumb, new_name)
		    File.open(path, "wb") { |f| f.write(source_photo.read) }
		    # 开始自动切割
		    origin_img = Magick::Image.read(path)
        # 得到了图片的对象
        org_img_obj = origin_img[0]
        # 100x100的
        medium = org_img_obj.crop_resized(300,300)
        medium.write(medium_path)
        # 300x300的
		    thumb = org_img_obj.crop_resized(100,100)#org_img_obj.resize(org_img_obj.columns*0.1, org_img_obj.rows*0.1)
        # 写出一个最小的缩略图
		    thumb.write(thumb_path)

        @source.update_attributes({
            :photo_file_name => new_name,
            :photo_content_type => source_photo.content_type,
            :photo_file_size => source_photo.size
        })
      else
        logger.debug 'source has no photo'
      end
      flash[:message] = "成功发布译文"
      user_count = UserCount.where("user_id = #{session[:login_user_id].to_s} and app_name = 'source'").first
       # 更新发布总数
      if not user_count
        user_count = UserCount.new
        user_count.user_id = session[:login_user_id]
        user_count.app_name = "source"
        user_count.uploads = 1
		     user_count.save
      else
        user_count.update_attributes({:uploads => user_count.uploads + 1 })
      end
       # 加积分 和金币
      add_discuz_credits @source.dz_user_id, 20
      add_discuz_extcredits @source.dz_user_id, 30
      # 发全站动态
      # 发送全局动态
      source_index_url = XMAPP_MAIN_DOMAIN_URL+"/sources"
      source_thread_url = XMAPP_MAIN_DOMAIN_URL+"/sources/#{@source.id}"
      title_template = "#{@source.username}在<a href=\"#{source_index_url}\" >译文频道<\/a>发布了一篇文章<a href=\"#{source_thread_url}\" >#{@source.title}<\/a>,并获得了30的金币,翻译此文章将有金币奖励,如果被评选为最佳翻译将额外获取获#{@source.excredits.to_s}的金币,快来<a href=\"#{source_thread_url}/translations/new\" >翻译<\/a>吧"
	    title_data = {}
	    require 'php_serialization'
	    title_data = PhpSerialization.dump(title_data)
      send_dz_feed 2003, @source.dz_user_id, @source.username, title_template, title_data, '', title_data
      # end 发送全局动态
       # 记录用户操作
      user_op_log session[:login_user_id] ,@source.dz_user_id, @source.username, 'all'
      redirect_to my_sources_path
    else
      flash[:error] = "保存错误,请重试"
      redirect_to new_source_path
    end
  end

  # PUT /sources/1
  # PUT /sources/1.xml
  def update
    @source = Source.find(params[:id])
    if params[:excredits]
      if @source.status != 3
        @source.update_attributes({:excredits => params[:excredits]})
        return
      end
    end

    if @source.update_attributes(params[:source])
      flash[:message] = "成功编辑译文"
      redirect_to my_sources_path
    else
      flash[:error] = "保存错误,请重试"
      redirect_to new_source_path
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.xml
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to(sources_url) }
      format.xml  { head :ok }
    end
  end
end

