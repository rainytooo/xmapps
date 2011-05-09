class Downloads::Admin::DlTypesController < ApplicationController
  before_filter :require_login , :require_admin
  # GET /dl_types
  # GET /dl_types.xml
  def index
	@dl_types = DlType.paginate(:page=>params[:page]||1,:per_page=>20)
	logger.info @dl_types.length
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dl_types }
    end
  end

  # GET /dl_types/1
  # GET /dl_types/1.xml
  def show
    @dl_type = DlType.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dl_type }
    end
  end

  # GET /dl_types/new
  # GET /dl_types/new.xml
  def new
    @dl_type = DlType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dl_type }
    end
  end
  
  def addsub
	@dl_type_parent = DlType.find(params[:id])
	@dl_type = DlType.new
	@dl_type.dl_type_id = @dl_type_parent.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dl_type }
    end
  end

  # GET /dl_types/1/edit
  def edit
    @dl_type = DlType.find(params[:id])
  end

  # POST /dl_types
  # POST /dl_types.xml
  def create
    @dl_type = DlType.new(params[:dl_type])
	#logger.info @dl_type.dl_type_id
	if @dl_type.dl_type
		logger.info @dl_type.dl_type.id
		@dl_type.type_lv = @dl_type.dl_type.type_lv + 1
	end
	
    respond_to do |format|
      if @dl_type.save
        format.html { redirect_to(downloads_admin_dl_types_url, :notice => 'Dl type was successfully created.') }
        format.xml  { render :xml => @dl_type, :status => :created, :location => @dl_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dl_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dl_types/1
  # PUT /dl_types/1.xml
  def update
    @dl_type = DlType.find(params[:id])

    respond_to do |format|
      if @dl_type.update_attributes(params[:dl_type])
        format.html { redirect_to(@dl_type, :notice => 'Dl type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dl_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dl_types/1
  # DELETE /dl_types/1.xml
  def destroy
	logger.info "destory method"
    @dl_type = DlType.find(params[:id])
    @dl_type.destroy

    respond_to do |format|
      format.html { redirect_to(downloads_admin_dl_types_url) }
      format.xml  { head :ok }
    end
  end
  
  # 下面是过滤器的定义部分
  private
 
  def require_login
	logger.info "check login"
    unless logged_in?
      flash[:error] = "必须登录才能继续刚才的操作"
      redirect_to login_url # halts request cycle
    end
  end
 
  def logged_in?
    !!session[:login_user]
  end
  
  def require_admin
	logger.info "check admin"
	unless logged_admin?
      flash[:error] = "你必须具有管理员权限"
      redirect_to login_url # halts request cycle
	end
  end
  
  def logged_admin?
	if session[:login_user].id == 1
	  return true
	else
	  return false
	end
  end
end