class AuditionsController < ApplicationController
  layout "asks_layout"
  # GET /auditions
  # GET /auditions.xml
  # def index
  #     @auditions = Audition.all
  # 
  #     respond_to do |format|
  #       format.html # index.html.erb
  #       format.xml  { render :xml => @auditions }
  #     end
  #   end

  # GET /auditions/1
  # GET /auditions/1.xml
  # def show
  #     @audition = Audition.find(params[:id])
  # 
  #     respond_to do |format|
  #       format.html # show.html.erb
  #       format.xml  { render :xml => @audition }
  #     end
  #   end

  # GET /auditions/new
  # GET /auditions/new.xml
  def new
    @audition = Audition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @audition }
    end
  end

  # GET /auditions/1/edit
  # def edit
  #     @audition = Audition.find(params[:id])
  #   end

  # POST /auditions
  # POST /auditions.xml
  def create
    @audition = Audition.new(params[:audition])
    respond_to do |format|
      if @audition.save
        format.html { redirect_to submit_result_s_auditions_path }
        format.xml  { render :xml => @audition, :status => :created, :location => @audition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @audition.errors, :status => :unprocessable_entity }
      end
    end
  end
  # 查询已经申请的人员
  def check_applies    
    render 'check_applies'
  end
  
  def applies
    password = params[:password]
    if password == '12349807'
      @auditions = Audition.order("created_at desc").paginate(:page=>params[:page]||1,:per_page=>30)
    else
      render :action => "check_applies"
    end
  end

  # PUT /auditions/1
  # PUT /auditions/1.xml
  # def update
  #     @audition = Audition.find(params[:id])
  # 
  #     respond_to do |format|
  #       if @audition.update_attributes(params[:audition])
  #         format.html { redirect_to(@audition, :notice => 'Audition was successfully updated.') }
  #         format.xml  { head :ok }
  #       else
  #         format.html { render :action => "edit" }
  #         format.xml  { render :xml => @audition.errors, :status => :unprocessable_entity }
  #       end
  #     end
  #   end

  # DELETE /auditions/1
  # DELETE /auditions/1.xml
  # def destroy
  #     @audition = Audition.find(params[:id])
  #     @audition.destroy
  # 
  #     respond_to do |format|
  #       format.html { redirect_to(auditions_url) }
  #       format.xml  { head :ok }
  #     end
  #   end
  
  # 报名结果
  def submit_result_s
    @message = "恭喜您!您的申请已经成功提交!5-7个工作日内,会有相关工作人员联系您!感谢您的参与和支持."
  end
end
