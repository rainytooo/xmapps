class AppliesController < ApplicationController
  # GET /applies
  # GET /applies.xml
  def index
    @applies = Apply.all
	# 添加了活动
	@campaign = Campaign.find(params[:campaign_id])
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
	
    respond_to do |format|
      if @apply.save
        format.html { redirect_to campaign_applies_path }
        format.xml  { render :xml => @apply, :status => :created, :location => @apply }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @apply.errors, :status => :unprocessable_entity }
      end
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
