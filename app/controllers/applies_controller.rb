class AppliesController < ApplicationController
  before_filter :require_login , :except => [:create, :new]
  before_filter :require_admin , :except => [:create, :new]
  # GET /applies
  # GET /applies.xml
  def index
    
     # 添加了活动
    @campaign = Campaign.find(params[:campaign_id])
    @applies = Apply.where("campaign_id = ?" , @@campaign.id).order("created_at desc")
    respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @applies }
    end
  end

  # GET /applies/1
  # GET /applies/1.xml
  def show
    @apply = Apply.find(params[:id])
	# 添加了活动
	@campaign = Campaign.find(params[:campaign_id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @apply }
    end
  end

  # GET /applies/new
  # GET /applies/new.xml
  def new
    @apply = Apply.new
	# 添加了活动
	@campaign = Campaign.find(params[:campaign_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @apply }
    end
  end

  # GET /applies/1/edit
  def edit
	# 添加了活动
	@campaign = Campaign.find(params[:campaign_id])
    @apply = Apply.find(params[:id])
  end

  # POST /applies
  # POST /applies.xml
  def create
    # 添加了活动
	@campaign = Campaign.find(params[:campaign_id])

	@apply = @campaign.applies.create(params[:apply])

    if @apply.save
      flash[:message] = "您已经成功预约了参与此次讲座活动:#{@campaign.name}"
      redirect_to campaigns_path
    else
      flash.now[:error] = "您填写的信息有误,请重新填写"
      render :action => "new"
    end

  end

  # PUT /applies/1
  # PUT /applies/1.xml
  def update
    @apply = Apply.find(params[:id])
	# 添加了活动
	@campaign = Campaign.find(params[:campaign_id])
    respond_to do |format|
      if @apply.update_attributes(params[:apply])
        format.html { redirect_to campaign_applies_path }
		#format.html { redirect_to(@campaign.applies, :notice => 'Apply was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @apply.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /applies/1
  # DELETE /applies/1.xml
  def destroy
    @apply = Apply.find(params[:id])
    @apply.destroy
	# 添加了活动
	@campaign = Campaign.find(params[:campaign_id])
    respond_to do |format|
	  format.html { redirect_to campaign_applies_path }
      #format.html { redirect_to(@campaign.applies, :notice => 'Apply was successfully destroyed.') }
      format.xml  { head :ok }
    end
  end
end

