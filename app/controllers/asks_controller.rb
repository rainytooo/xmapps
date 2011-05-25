class AsksController < ApplicationController
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ask }
    end
  end

  # GET /asks/1/edit
  def edit
    @ask = Ask.find(params[:id])
  end

  # POST /asks
  # POST /asks.xml
  def create
    @ask = Ask.new(params[:ask])

    respond_to do |format|
      if @ask.save
        format.html { redirect_to(@ask, :notice => 'Ask was successfully created.') }
        format.xml  { render :xml => @ask, :status => :created, :location => @ask }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ask.errors, :status => :unprocessable_entity }
      end
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
