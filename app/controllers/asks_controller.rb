class AsksController < ApplicationController
  before_filter :require_login , :except => [:index, :show]
  # GET /asks
  # GET /asks.xml
  def index
    @asks = Ask.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @asks }
    end
  end

  # GET /asks/1
  # GET /asks/1.xml
  def show
    @ask = Ask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ask }
    end
  end

  # GET /asks/new
  # GET /asks/new.xml
  def new
    @ask = Ask.new
  end

  # GET /asks/1/edit
  def edit
    @ask = Ask.find(params[:id])
  end

  # POST /asks
  # POST /asks.xml
  def create
    @ask = Ask.new(params[:ask])
    if @ask.save
      redirect_to(@ask, :notice => 'Ask was successfully created.')
    else
      flash.now[:error] = "您提交的问题出现了错误"
      render :action => "new"
    end
  end

  # PUT /asks/1
  # PUT /asks/1.xml
  def update
    @ask = Ask.find(params[:id])

    respond_to do |format|
      if @ask.update_attributes(params[:ask])
        format.html { redirect_to(@ask, :notice => 'Ask was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ask.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /asks/1
  # DELETE /asks/1.xml
  def destroy
    @ask = Ask.find(params[:id])
    @ask.destroy

    respond_to do |format|
      format.html { redirect_to(asks_url) }
      format.xml  { head :ok }
    end
  end
end

