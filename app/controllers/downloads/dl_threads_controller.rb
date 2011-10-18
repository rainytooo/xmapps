require 'uri'
require 'ftools'
require 'rubygems'
require 'uuidtools'

require 'RMagick'
include Magick
class Downloads::DlThreadsController < ApplicationController
  before_filter :require_login , :except => [:index, :show, :category, :search]
  # GET /dl_threads
  # GET /dl_threads.xml
  def index
	  # 拿出所有审核过的下载
	  @dl_threads = DlThread.where("ispass = ?", 1).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
	  # 拿出最多上传的用户
	  #@rank_users = User.find_by_sql('select * from users LEFT OUTER JOIN user_counts ON user_counts.user_id = users.id where user_counts.uploads != 0 order by user_counts.uploads desc limit 0, 12')
	  # 拿出最热下载
	  #@hot_dl_threads = DlThread.where("ispass = ?", 1).order("views DESC").limit(10).offset(0)
	  # 本周热门
	  date_after = Date.today - 7
	  @week_hot = DlThread.where("ispass = ? and created_at >= ?", 1, date_after).order("views DESC").order("created_at DESC").limit(10).offset(0)
	  # 最新免金币下载资源
    @free_dl = DlThread.where("ispass = 1 and gold = 0").order("created_at DESC").limit(10).offset(0)
    # 精华和推荐
    @tuijian = DlThread.where("ispass = 1 and ( level = 1 or level = 2 )").order("created_at DESC").limit(10).offset(0)
  end

  # 分类浏览
  def category
	@dl_category = DlType.find_by_id(params[:id])
	# 拿出所有审核过的下载
	@dl_threads = DlThread.where(" ispass = 1 and ( dl_type_id in (select id from dl_types where dl_type_id = :dl_type_id ) or dl_type_id = :dl_type_id )  ", {:dl_type_id => params[:id]}).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
	if @dl_threads.empty?
		flash[:message] = "对不起,没有此分类的相关下载"
	end
	# 拿出最多上传的用户
	#@rank_users = User.find_by_sql('select * from users LEFT OUTER JOIN user_counts ON user_counts.user_id = users.id order by user_counts.uploads desc limit 0, 10')
	# 拿出最热下载
	@hot_dl_threads = DlThread.where("ispass = 1 and dl_type_id = :dl_type_id ", {:dl_type_id => params[:id]}).order("views DESC").limit(10).offset(0)
  end

  # GET /dl_threads/1
  # GET /dl_threads/1.xml
  def show
	  @dl_thread = DlThread.find_by_id(params[:id])
	  =begin
	  user_question = Questionnaire.find_by_user_id(session[:login_user_id])
	  if not user_question
		# 保存浏览的下载的id
	    if "development" == Rails.env
          cookies[:last_dl_id] = {
            :value => @dl_thread.id,
            :expires => 1.hour.from_now
            #:domain => COOKIE_DOMAIN_NAME
           }
        elsif "production" == Rails.env
          cookies[:last_dl_id] = {
            :value => @dl_thread.id,
            :expires => 1.hour.from_now,
            :domain => COOKIE_DOMAIN_NAME
           }
        end
		redirect_to XMAPP_MAIN_DOMAIN_URL + "/questionnaires/new"
		return
      end
	  =end
	  if not @dl_thread
		  flash[:message] = "对不起,此资源不存在或者已被删除"
	  else
		  if @dl_thread.ispass == 0
			  @dl_thread = nil
			  flash[:message] = "对不起,此资源不存在或者已被删除"
		  else
			  #flash[:message] = "对不起,此资源不存在或者已被删除"
			  @dl_attachments = DlAttachment.where("dl_thread_id  = ?", @dl_thread.id)
			  @tags = Tag.joins('LEFT OUTER JOIN tag_relationships ON tag_relationships.tag_id = tags.id ').where('tag_relationships.object_id = ?', @dl_thread.id)
			  ActiveRecord::Base.connection.update("update dl_threads set views = views+1 where id = " + @dl_thread.id.to_s)
		  end


	  end


	  # if not @dl_thread
		  # raise ActiveRecord::NotFound
		  # render :status => 404
		  # render '/404.html'
	  # end

  end

  # GET /dl_threads/new
  # GET /dl_threads/new.xml
  def new
    @dl_thread = DlThread.new
  end

  # 快速上传资源
  def simplenew
	  #user_id = session[:login_user_id]
    #last_id = DlThread.maximum('id')
	  #current_id = last_id ? last_id + 1 : 1
	  #t = Time.now
	  #created_at = t.strftime("%Y-%m-%d %H:%M:%S")
	  #ActiveRecord::Base.connection.insert("insert into dl_threads (id,user_id,created_at,updated_at,dl_type_id,name) values(#{current_id},#{user_id},'#{created_at}','#{created_at}',2,'该资源名称未定义' ) ")
	  #@dl_thread = DlThread.find_by_id(current_id)
  end


  # GET /dl_threads/1/edit
  def edit
	  @dl_thread = DlThread.find(params[:id])
	  if  @dl_thread.user_id == session[:login_user_id]  or logged_admin?
		  @tags = Tag.joins('LEFT OUTER JOIN tag_relationships ON tag_relationships.tag_id = tags.id ').
          where('tag_relationships.object_id = ?',      @dl_thread.id)
		  @tag_names = Array.new
		  @tags.each { |tag| @tag_names.push tag.name  }
	  else
		  flash.now[:error] = "对不起,您无权进行此操作"
		  render '/errors_messages.html'
	  end

  end

  # 快速上传资源
  def simplecreate
	  @dl_thread = DlThread.new #DlThread.find_by_id(params[:thread_id])

	  dl_photo = params[:photo]
	  if dl_photo
		  logger.debug 'has threads photo'
		  # 保存
		  @dl_thread.dl_type_id = params[:dl_type_id]
		  @dl_thread.name = params[:thread_name]
		  @dl_thread.content_desc = params[:content_desc]
		  @dl_thread.gold = params[:gold]
		  #@dl_thread.photo_file_name = new_name
		  #@dl_thread.photo_content_type = dl_photo.content_type
		  #@dl_thread.photo_file_size = dl_photo.size
		  @dl_thread.user_id  = session[:login_user_id]
		  @dl_thread.save
		  # 创建路径
		  # 初始化日期路径
		  #年月日
		  year_s = @dl_thread.created_at.year.to_s
		  month_s = @dl_thread.created_at.month.to_s
		  day_s = @dl_thread.created_at.day.to_s
		  # 除去配置文件的路径
		  file_folder = File.join("photos",year_s, month_s, day_s,@dl_thread.id.to_s)
		  base_dir = File.join(DOWNLOAD_THREAD_PHOTO_ROOT_PATH, file_folder)
		  base_dir_medium = File.join(DOWNLOAD_THREAD_PHOTO_ROOT_PATH, file_folder, "medium")
		  base_dir_original = File.join(DOWNLOAD_THREAD_PHOTO_ROOT_PATH, file_folder, "original")
		  base_dir_thumb = File.join(DOWNLOAD_THREAD_PHOTO_ROOT_PATH, file_folder, "thumb")
		  if not File.exist?(base_dir)
			  File.makedirs(base_dir_medium)
			  File.makedirs(base_dir_original)
			  File.makedirs(base_dir_thumb)
		  end
		  # 重写文件名 ,这里需要从配置文件里读取根路径,然后根据日期创建目录(如果已经存在就不创建), 用uuid重命名
		  name =  dl_photo.original_filename
		  # 文件名后缀
		  ext = File.extname(name)
		  new_name = UUIDTools::UUID.timestamp_create.to_s.gsub('-','') + ext
		  path = File.join(base_dir_original, new_name)
		  medium_path = File.join(base_dir_medium, new_name)
		  thumb_path = File.join(base_dir_thumb, new_name)
		  File.open(path, "wb") { |f| f.write(dl_photo.read) }
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

      @dl_thread.update_attributes({
          :photo_file_name => new_name,
          :photo_content_type => dl_photo.content_type,
          :photo_file_size => dl_photo.size
      })
	  else
		  logger.debug 'has not threads photo'
      #@dl_thread.update_attributes({:dl_type_id => params[:dl_type_id], :name => params[:thread_name], :content_desc => params[:content_desc] })
      @dl_thread.dl_type_id = params[:dl_type_id]
		  @dl_thread.name = params[:thread_name]
		  @dl_thread.content_desc = params[:content_desc]
		  @dl_thread.user_id  = session[:login_user_id]
		  @dl_thread.save
	  end
	  @dl_attachment = DlAttachment.new
		redirect_to downloads_dl_thread_dl_attachments_path(@dl_thread)
    #redirect_to dl_index_path
  end



  # POST /dl_threads
  # POST /dl_threads.xml
  def create
    @dl_thread = DlThread.new(params[:dl_thread])
	  @dl_thread.user_id = session[:login_user_id].to_i
	  @dl_thread.dl_type_id = params[:dl_type_id]
    if @dl_thread.save
	    handle_tags params[:tag_names], @dl_thread
	    if params[:dl_thread][:photo].blank?
	      redirect_to([:downloads, @dl_thread], :notice => 'Dl thread was successfully created.')
	    else
	      render :action => "crop"
	    end
    else
      render :action => "new"
    end
  end

  # PUT /dl_threads/1
  # PUT /dl_threads/1.xml
  def update
    @dl_thread = DlThread.find(params[:id])
	  @dl_thread.update_attributes(params[:dl_thread])
    if @dl_thread.update_attributes(params[:dl_thread])
	  if params[:crop] == "1"
		  # 如果是切图,转到第三步 上传文件
	    @dl_attachment = DlAttachment.new
		  redirect_to new_downloads_dl_thread_dl_attachment_path(@dl_thread, @dl_attachment)
	  elsif params[:recrop] == "1"
		# 这是重新便激动 直接跳转到编辑界面
		@dl_threads = DlThread.where("user_id = ?", session[:login_user_id]).paginate(:page=>params[:page]||1,:per_page=>10)
		redirect_to manage_uploads_path
	  else
		# 如果只是编辑,编辑完了去我的首页
		update_tags params[:tag_names], @dl_thread
		redirect_to manage_uploads_path
	  end

    else
	  flash[:error] = "更新属性时出现错误,请重试"
      render :action => "edit"
    end
  end

  # DELETE /dl_threads/1
  # DELETE /dl_threads/1.xml
  def destroy
    @dl_thread = DlThread.find(params[:id])
    @dl_thread.destroy
    redirect_to(dl_threads_url)

  end

  # 重新编辑缩略图
  def recrop
    @dl_thread = DlThread.find(params[:id])
  end

  # 重新上传图片
  def reuploadimg
	@dl_thread = DlThread.find(params[:id])
  end

  private
  @@fchars = '　！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～'
  @@hhash = {' '=>'　','!'=>'！','"'=>'＂','#'=>'＃','$'=>'＄','%'=>'％','&'=>'＆','\''=>'＇','('=>'（',')'=>'）','*'=>'＊','+'=>'＋',','=>'，','-'=>'－','.'=>'．','/'=>'／','0'=>'０','1'=>'１','2'=>'２','3'=>'３','4'=>'４','5'=>'５','6'=>'６','7'=>'７','8'=>'８','9'=>'９',':'=>'：',';'=>'；','<'=>'＜','='=>'＝','>'=>'＞','?'=>'？','@'=>'＠','A'=>'Ａ','B'=>'Ｂ','C'=>'Ｃ','D'=>'Ｄ','E'=>'Ｅ','F'=>'Ｆ','G'=>'Ｇ','H'=>'Ｈ','I'=>'Ｉ','J'=>'Ｊ','K'=>'Ｋ','L'=>'Ｌ','M'=>'Ｍ','N'=>'Ｎ','O'=>'Ｏ','P'=>'Ｐ','Q'=>'Ｑ','R'=>'Ｒ','S'=>'Ｓ','T'=>'Ｔ','U'=>'Ｕ','V'=>'Ｖ','W'=>'Ｗ','X'=>'Ｘ','Y'=>'Ｙ','Z'=>'Ｚ','['=>'［','\\'=>'＼',']'=>'］','^'=>'＾','_'=>'＿','`'=>'｀','a'=>'ａ','b'=>'ｂ','c'=>'ｃ','d'=>'ｄ','e'=>'ｅ','f'=>'ｆ','g'=>'ｇ','h'=>'ｈ','i'=>'ｉ','j'=>'ｊ','k'=>'ｋ','l'=>'ｌ','m'=>'ｍ','n'=>'ｎ','o'=>'ｏ','p'=>'ｐ','q'=>'ｑ','r'=>'ｒ','s'=>'ｓ','t'=>'ｔ','u'=>'ｕ','v'=>'ｖ','w'=>'ｗ','x'=>'ｘ','y'=>'ｙ','z'=>'ｚ','{'=>'｛','|'=>'｜','}'=>'｝','~'=>'～',}
  @@fhash = {'　'=>' ','！'=>'!','＂'=>'"','＃'=>'#','＄'=>'$','％'=>'%','＆'=>'&','＇'=>'\'','（'=>'(','）'=>')','＊'=>'*','＋'=>'+','，'=>',','－'=>'-','．'=>'.','／'=>'/','０'=>'0','１'=>'1','２'=>'2','３'=>'3','４'=>'4','５'=>'5','６'=>'6','７'=>'7','８'=>'8','９'=>'9','：'=>':','；'=>';','＜'=>'<','＝'=>'=','＞'=>'>','？'=>'?','＠'=>'@','Ａ'=>'A','Ｂ'=>'B','Ｃ'=>'C','Ｄ'=>'D','Ｅ'=>'E','Ｆ'=>'F','Ｇ'=>'G','Ｈ'=>'H','Ｉ'=>'I','Ｊ'=>'J','Ｋ'=>'K','Ｌ'=>'L','Ｍ'=>'M','Ｎ'=>'N','Ｏ'=>'O','Ｐ'=>'P','Ｑ'=>'Q','Ｒ'=>'R','Ｓ'=>'S','Ｔ'=>'T','Ｕ'=>'U','Ｖ'=>'V','Ｗ'=>'W','Ｘ'=>'X','Ｙ'=>'Y','Ｚ'=>'Z','［'=>'[','＼'=>'\\','］'=>']','＾'=>'^','＿'=>'_','｀'=>'`','ａ'=>'a','ｂ'=>'b','ｃ'=>'c','ｄ'=>'d','ｅ'=>'e','ｆ'=>'f','ｇ'=>'g','ｈ'=>'h','ｉ'=>'i','ｊ'=>'j','ｋ'=>'k','ｌ'=>'l','ｍ'=>'m','ｎ'=>'n','ｏ'=>'o','ｐ'=>'p','ｑ'=>'q','ｒ'=>'r','ｓ'=>'s','ｔ'=>'t','ｕ'=>'u','ｖ'=>'v','ｗ'=>'w','ｘ'=>'x','ｙ'=>'y','ｚ'=>'z','｛'=>'{','｜'=>'|','｝'=>'}','～'=>'~',}

  def handle_tags(tags, dl_thread)
	# 标签处理
	if tags
		# 全角替换
		tags.strip
		tags.gsub!(/([#{@@fchars}])/){|c|@@fhash[c]}
		tags.squeeze("\s")
		tags.gsub!("\s",",")
		# 生成数组
		tags_array = tags.split(/,/)
		tags_array.each do |tag|
			if not tag == "\s"
				db_tag = Tag.find_by_name(tag)
				if not db_tag
					tag_new = Tag.new
					tag_new.name = tag
					tag_new.slug = URI.escape(tag)
					tag_new.save
					db_tag = tag_new
				end
				tag_relationship = TagRelationship.new
				tag_relationship.tag_id = db_tag.id
				tag_relationship.object_id = dl_thread.id
				tag_relationship.taxonomy = 'downloads_tag'
				tag_relationship.save
				# 更新这个标签的 引用数量
				tag_count = TagRelationship.where("tag_id = ? ", db_tag.id).count
				ActiveRecord::Base.connection.update("update tags set count = #{tag_count} where id = #{db_tag.id}")
			end
		end
	end
  end

  def update_tags(tags, dl_thread)
	# 先删除所有的
	ActiveRecord::Base.connection.update("delete from tag_relationships where object_id = " + dl_thread.id.to_s)
	handle_tags tags, dl_thread
  end
end

