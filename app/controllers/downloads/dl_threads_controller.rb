require 'uri'
class Downloads::DlThreadsController < ApplicationController
  before_filter :require_login , :except => [:index, :show, :category]
  # GET /dl_threads
  # GET /dl_threads.xml
  def index
	# 拿出所有审核过的下载
	@dl_threads = DlThread.where("ispass = ?", 1).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
	# 拿出最多上传的用户
	@rank_users = User.find_by_sql('select * from users LEFT OUTER JOIN user_counts ON user_counts.user_id = users.id where user_counts.uploads != 0 order by user_counts.uploads desc limit 0, 12')
	# 拿出最热下载
	@hot_dl_threads = DlThread.where("ispass = ?", 1).order("views DESC").limit(10).offset(0)
  end
  
  # 分类浏览
  def category
	@dl_category = DlType.find_by_id(params[:id])
	# 拿出所有审核过的下载
	@dl_threads = DlThread.where("ispass = 1 and dl_type_id = :dl_type_id ", {:dl_type_id => params[:id]}).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
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
	@dl_thread = DlThread.find(params[:id])
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
	#@dl_image = DlImage.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dl_thread }
    end
  end

  # GET /dl_threads/1/edit
  def edit
    @dl_thread = DlThread.find(params[:id])
	@tags = Tag.joins('LEFT OUTER JOIN tag_relationships ON tag_relationships.tag_id = tags.id ').where('tag_relationships.object_id = ?', @dl_thread.id)
	@tag_names = Array.new
	@tags.each { |tag| @tag_names.push tag.name  }
  end

  # POST /dl_threads
  # POST /dl_threads.xml
  def create
    @dl_thread = DlThread.new(params[:dl_thread])
	@dl_thread.user_id = session[:login_user_id].to_i
	@dl_thread.dl_type_id = params[:dl_type_id]
    respond_to do |format|
      if @dl_thread.save
		handle_tags params[:tag_names], @dl_thread
		if params[:dl_thread][:photo].blank?
		  format.html { redirect_to([:downloads, @dl_thread], :notice => 'Dl thread was successfully created.') }
		else
		  format.html { render :action => "crop" }
		end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dl_thread.errors, :status => :unprocessable_entity }
      end
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
  
  private
  @@fchars = '　！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～'  
  @@hhash = {' '=>'　','!'=>'！','"'=>'＂','#'=>'＃','$'=>'＄','%'=>'％','&'=>'＆','\''=>'＇','('=>'（',')'=>'）','*'=>'＊','+'=>'＋',','=>'，','-'=>'－','.'=>'．','/'=>'／','0'=>'０','1'=>'１','2'=>'２','3'=>'３','4'=>'４','5'=>'５','6'=>'６','7'=>'７','8'=>'８','9'=>'９',':'=>'：',';'=>'；','<'=>'＜','='=>'＝','>'=>'＞','?'=>'？','@'=>'＠','A'=>'Ａ','B'=>'Ｂ','C'=>'Ｃ','D'=>'Ｄ','E'=>'Ｅ','F'=>'Ｆ','G'=>'Ｇ','H'=>'Ｈ','I'=>'Ｉ','J'=>'Ｊ','K'=>'Ｋ','L'=>'Ｌ','M'=>'Ｍ','N'=>'Ｎ','O'=>'Ｏ','P'=>'Ｐ','Q'=>'Ｑ','R'=>'Ｒ','S'=>'Ｓ','T'=>'Ｔ','U'=>'Ｕ','V'=>'Ｖ','W'=>'Ｗ','X'=>'Ｘ','Y'=>'Ｙ','Z'=>'Ｚ','['=>'［','\\'=>'＼',']'=>'］','^'=>'＾','_'=>'＿','`'=>'｀','a'=>'ａ','b'=>'ｂ','c'=>'ｃ','d'=>'ｄ','e'=>'ｅ','f'=>'ｆ','g'=>'ｇ','h'=>'ｈ','i'=>'ｉ','j'=>'ｊ','k'=>'ｋ','l'=>'ｌ','m'=>'ｍ','n'=>'ｎ','o'=>'ｏ','p'=>'ｐ','q'=>'ｑ','r'=>'ｒ','s'=>'ｓ','t'=>'ｔ','u'=>'ｕ','v'=>'ｖ','w'=>'ｗ','x'=>'ｘ','y'=>'ｙ','z'=>'ｚ','{'=>'｛','|'=>'｜','}'=>'｝','~'=>'～',}  
  @@fhash = {'　'=>' ','！'=>'!','＂'=>'"','＃'=>'#','＄'=>'$','％'=>'%','＆'=>'&','＇'=>'\'','（'=>'(','）'=>')','＊'=>'*','＋'=>'+','，'=>',','－'=>'-','．'=>'.','／'=>'/','０'=>'0','１'=>'1','２'=>'2','３'=>'3','４'=>'4','５'=>'5','６'=>'6','７'=>'7','８'=>'8','９'=>'9','：'=>':','；'=>';','＜'=>'<','＝'=>'=','＞'=>'>','？'=>'?','＠'=>'@','Ａ'=>'A','Ｂ'=>'B','Ｃ'=>'C','Ｄ'=>'D','Ｅ'=>'E','Ｆ'=>'F','Ｇ'=>'G','Ｈ'=>'H','Ｉ'=>'I','Ｊ'=>'J','Ｋ'=>'K','Ｌ'=>'L','Ｍ'=>'M','Ｎ'=>'N','Ｏ'=>'O','Ｐ'=>'P','Ｑ'=>'Q','Ｒ'=>'R','Ｓ'=>'S','Ｔ'=>'T','Ｕ'=>'U','Ｖ'=>'V','Ｗ'=>'W','Ｘ'=>'X','Ｙ'=>'Y','Ｚ'=>'Z','［'=>'[','＼'=>'\\','］'=>']','＾'=>'^','＿'=>'_','｀'=>'`','ａ'=>'a','ｂ'=>'b','ｃ'=>'c','ｄ'=>'d','ｅ'=>'e','ｆ'=>'f','ｇ'=>'g','ｈ'=>'h','ｉ'=>'i','ｊ'=>'j','ｋ'=>'k','ｌ'=>'l','ｍ'=>'m','ｎ'=>'n','ｏ'=>'o','ｐ'=>'p','ｑ'=>'q','ｒ'=>'r','ｓ'=>'s','ｔ'=>'t','ｕ'=>'u','ｖ'=>'v','ｗ'=>'w','ｘ'=>'x','ｙ'=>'y','ｚ'=>'z','｛'=>'{','｜'=>'|','｝'=>'}','～'=>'~',} 
  
  def handle_tags(tags, dl_thread)
	# 标签处理
	if tags
		# 全角替换
		tags.lstrip!
		tags.gsub!(/([#{@@fchars}])/){|c|@@fhash[c]}
		tags.squeeze!("\s")
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
