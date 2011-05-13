class Downloads::DlThreadsController < ApplicationController
  # GET /dl_threads
  # GET /dl_threads.xml
  def index
    @dl_threads = DlThread.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dl_threads }
    end
  end

  # GET /dl_threads/1
  # GET /dl_threads/1.xml
  def show
    @dl_thread = DlThread.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dl_thread }
    end
  end

  # GET /dl_threads/new
  # GET /dl_threads/new.xml
  def new
    @dl_thread = DlThread.new
	@dl_image = DlImage.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dl_thread }
    end
  end

  # GET /dl_threads/1/edit
  def edit
    @dl_thread = DlThread.find(params[:id])
  end

  # POST /dl_threads
  # POST /dl_threads.xml
  def create
    @dl_thread = DlThread.new(params[:dl_thread])

    respond_to do |format|
      if @dl_thread.save
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
    respond_to do |format|
      if @dl_thread.update_attributes(params[:dl_thread])
		format.html { redirect_to([:downloads, @dl_thread], :notice => 'Dl thread was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dl_thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dl_threads/1
  # DELETE /dl_threads/1.xml
  def destroy
    @dl_thread = DlThread.find(params[:id])
    @dl_thread.destroy

    respond_to do |format|
      format.html { redirect_to(dl_threads_url) }
      format.xml  { head :ok }
    end
  end
end
