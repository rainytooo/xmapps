class DlAttachmentsController < ApplicationController
  # GET /dl_attachments
  # GET /dl_attachments.xml
  def index
    @dl_attachments = DlAttachment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dl_attachments }
    end
  end

  # GET /dl_attachments/1
  # GET /dl_attachments/1.xml
  def show
    @dl_attachment = DlAttachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dl_attachment }
    end
  end

  # GET /dl_attachments/new
  # GET /dl_attachments/new.xml
  def new
    @dl_attachment = DlAttachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dl_attachment }
    end
  end

  # GET /dl_attachments/1/edit
  def edit
    @dl_attachment = DlAttachment.find(params[:id])
  end

  # POST /dl_attachments
  # POST /dl_attachments.xml
  def create
    @dl_attachment = DlAttachment.new(params[:dl_attachment])

    respond_to do |format|
      if @dl_attachment.save
        format.html { redirect_to(@dl_attachment, :notice => 'Dl attachment was successfully created.') }
        format.xml  { render :xml => @dl_attachment, :status => :created, :location => @dl_attachment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dl_attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dl_attachments/1
  # PUT /dl_attachments/1.xml
  def update
    @dl_attachment = DlAttachment.find(params[:id])

    respond_to do |format|
      if @dl_attachment.update_attributes(params[:dl_attachment])
        format.html { redirect_to(@dl_attachment, :notice => 'Dl attachment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dl_attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dl_attachments/1
  # DELETE /dl_attachments/1.xml
  def destroy
    @dl_attachment = DlAttachment.find(params[:id])
    @dl_attachment.destroy

    respond_to do |format|
      format.html { redirect_to(dl_attachments_url) }
      format.xml  { head :ok }
    end
  end
end
