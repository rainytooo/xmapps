class AsksController < ApplicationController
  before_filter :require_login , :except => [:index, :show]
  # GET /asks
  # GET /asks.xml
  def index
    # 热点问题
    @hot_asks = Ask.order("views ASC").limit(10)
    # 未解决问题
    @unsolve_asks = Ask.where("status = 0").order("created_at DESC").limit(10)
    # 已解决问题
    @solved_asks = Ask.where("status = 1").order("created_at DESC").limit(10)
  end

  # GET /asks/1
  # GET /asks/1.xml
  def show
    @ask = Ask.find(params[:id])
    @ask_answers = AskAnswer.where("ask_id = :ask_id" , {:ask_id => params[:id]}).order("created_at desc").limit(10)
  end

  def my
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
    @ask.ask_type_id = params[:ask_type_id]
    @ask.typename = AskType.find_by_id(params[:ask_type_id]).name
    @ask.user_id = session[:login_user_id]
    @ask.expiredtime = Time.now.to_i + 20#60*60*24*15
    logger.debug 'now time is ' + Time.now.to_s + 'this question will auto close until ' + @ask.expiredtime.to_s
    if @ask.save
      # 发送全局动态
      dz_user = session[:login_user]
      ask_index_url = XMAPP_MAIN_DOMAIN_URL+"/asks"
      ask_thread_url = XMAPP_MAIN_DOMAIN_URL+"/asks/#{@ask.id}"
      title_template = "#{dz_user.username}在<a href=\"#{ask_index_url}\" >问答频道<\/a>提了一个问题<a href=\"#{ask_thread_url}\" >#{@ask.title}<\/a>"
	    title_data = {}
	    require 'php_serialization'
	    title_data = PhpSerialization.dump(title_data)
      send_dz_feed 2002, dz_user.uid, dz_user.username, title_template, title_data, '', title_data
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
    # 补充问题的
    if params[:answers_content_renew]
      renew = "<br/><hr/>问题补充:<br/>" + params[:answers_content_renew]
      new_content = @ask.content + renew
      @ask.update_attributes({ :content => new_content })
      flash[:message] = "成功补充了您的问题"
    end
    # 更新状态的
    if params[:status] == 2.to_s
      @ask.update_attributes({ :status => params[:status] })
      flash[:message] = "您的问题已经正常关闭"
    elsif params[:status] == 1.to_s
      bestanswer = AskAnswer.find_by_id params[:answer_id]
      @ask.update_attributes({
        :status => params[:status],
        :bestanswer => bestanswer.id,
        :bestanswer_uid => bestanswer.user_id,
        :bestanswer_username => bestanswer.user.username
       })
      flash[:message] = "您的问题已经正常关闭,并且选择了正确答案"
      # 给解决问题的人发通知
      your_ask_url = XMAPP_MAIN_DOMAIN_URL+"/asks/#{@ask.id}"
      message = "您对问题<a href=\"#{your_ask_url}\" >#{@ask.title}<\/a>的回答被选择为正确答案,系统将赏给你20个金币"
      send_dz_notify bestanswer.user.dz_common_id, @ask.user.dz_common_id, '', message, 'slove_ask'
      # 给解决问题的人加金币
      add_discuz_extcredits bestanswer.user.dz_common_id, 20
      # 发全站动态
      dz_user = session[:login_user]
      ask_index_url = XMAPP_MAIN_DOMAIN_URL+"/asks"
      ask_thread_url = XMAPP_MAIN_DOMAIN_URL+"/asks/#{@ask.id}"
      #title_template = "#{dz_user.username}在<a href=\"#{ask_index_url}\" >问答频道<\/a>提了一个问题<a href=\"#{ask_thread_url}\" >#{@ask.title}<\/a>"
	    answer_user_url = USER_SPACE_URL_BASE.gsub('{dz_uid}', bestanswer.user.dz_common_id.to_s)
	    ask_user_url = USER_SPACE_URL_BASE.gsub('{dz_uid}', @ask.user.dz_common_id.to_s)
	    title_template = "<a href=\"#{answer_user_url}\" >#{@ask.bestanswer_username}<\/a>解决了<a href=\"#{ask_user_url}\" >#{@ask.user.username}<\/a>的问题<a href=\"\/asks\/#{@ask.id}\" >#{@ask.title}<\/a>"
	    title_data = {}
	    require 'php_serialization'
	    title_data = PhpSerialization.dump(title_data)
      send_dz_feed 2003, bestanswer.user.dz_common_id, @ask.bestanswer_username, title_template, title_data, '', title_data
    end
    redirect_to ask_path @ask
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

