class QuestionnairesController < ApplicationController
  before_filter :require_login
  # GET /questionnaires
  # GET /questionnaires.xml
  def index
    @questionnaires = Questionnaire.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questionnaires }
    end
  end

  # GET /questionnaires/1
  # GET /questionnaires/1.xml
  def show
    @questionnaire = Questionnaire.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @questionnaire }
    end
  end

  # GET /questionnaires/new
  # GET /questionnaires/new.xml
  def new
    @questionnaire = Questionnaire.new
  end

  # GET /questionnaires/1/edit
  def edit
    @questionnaire = Questionnaire.find(params[:id])
  end

  # POST /questionnaires
  # POST /questionnaires.xml
  def create
    @questionnaire = Questionnaire.new(params[:questionnaire])
    @questionnaire.age = params[:age]
    @questionnaire.user_id  = session[:login_user_id]
    if @questionnaire.save
      dl_id = cookies[:last_dl_id]
      redirect_to downloads_dl_thread_path dl_id.to_i
    else
      render :action => "new"
    end
  end

  # PUT /questionnaires/1
  # PUT /questionnaires/1.xml
  def update
    @questionnaire = Questionnaire.find(params[:id])

    respond_to do |format|
      if @questionnaire.update_attributes(params[:questionnaire])
        format.html { redirect_to(@questionnaire, :notice => 'Questionnaire was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questionnaires/1
  # DELETE /questionnaires/1.xml
  def destroy
    @questionnaire = Questionnaire.find(params[:id])
    @questionnaire.destroy

    respond_to do |format|
      format.html { redirect_to(questionnaires_url) }
      format.xml  { head :ok }
    end
  end
end

