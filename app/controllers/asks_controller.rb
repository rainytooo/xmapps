class AsksController < ApplicationController
  layout "asks_layout"
  before_filter :require_login , :except => [:index, :show, :unsolved, :closed, :tags]
  before_filter :require_sync_check_status, :only => [:create]
  before_filter :require_operation_check , :only => [:create]
  before_filter :require_dz_credits , :only => [:new]
  # GET /asks
  # GET /asks.xml
  def index
    date_after = Date.today - 14
    logger.debug date_after
    # 热点问题
    @hot_asks = Ask.where("created_at >= ?", date_after).order("views DESC, replies DESC").limit(10)
    # 未解决问题
    @unsolve_asks = Ask.where("status = 0").order("created_at DESC").limit(10)
    # 已解决问题
    @solved_asks = Ask.where("status = 1").order("created_at DESC").limit(10)
    @tag_asks_1 = Ask.where("ask_type_id = 1").order("created_at DESC").limit(10).limit(5)
    @tag_asks_2 = Ask.where("ask_type_id = 2").order("created_at DESC").limit(10).limit(5)
    @tag_asks_3 = Ask.where("ask_type_id = 3").order("created_at DESC").limit(10).limit(5)
    @tag_asks_4 = Ask.where("ask_type_id = 4").order("created_at DESC").limit(10).limit(5)
    @tag_asks_5 = Ask.where("ask_type_id = 5").order("created_at DESC").limit(10).limit(5)
    @tag_asks_6 = Ask.where("ask_type_id = 6").order("created_at DESC").limit(10).limit(5)
  end

  # GET /asks/1
  # GET /asks/1.xml
  def show
    @ask = Ask.find(params[:id])
    ActiveRecord::Base.connection.update("update asks set views = views+1 where id = #{@ask.id}")
    @ask_answers = AskAnswer.where("ask_id = :ask_id" , {:ask_id => params[:id]}).order("created_at desc")
  end
  # 我的问答
  def my
    # 我提问的问题
    @my_asks = Ask.where("user_id = ?" , session[:login_user_id])
    # 我回答的问题
    @my_answer_asks = Ask.find_by_sql("SELECT  asks.*
      FROM asks
      right outer JOIN
      (select distinct (ask_answers.ask_id) as answer_ask_id from ask_answers  where ask_answers.user_id = #{session[:login_user_id]} )
      b ON asks.id = b.answer_ask_id
      ORDER by asks.created_at desc")
    # 我解决的问题
    @my_solved_asks = Ask.where("bestanswer_uid = ?", session[:login_user_id])
  end

  # 未解决的
  def unsolved
    @unsolve_asks = Ask.where("status = 0").order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>30)
  end

  # 已关闭的
  def closed
    @solved_asks = Ask.where("status = 1").order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>30)
  end

  # 标签
  def tags
    @ask_type = AskType.find_by_name(params[:id])
    @tag_asks = Ask.where("ask_type_id = ?", @ask_type.id).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>30)
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
    # 设置15天以后过期
    @ask.expiredtime = Time.now.to_i + 60*60*24*15
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
      # 记录用户操作
      user_op_log session[:login_user_id] ,dz_user.uid, dz_user.username, 'all'
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
      if not @ask.content
        new_content = renew
      else
        new_content = @ask.content + renew
      end
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
      message = "您对问题<a href=\"#{your_ask_url}\" >#{@ask.title}<\/a>的回答被选择为正确答案,系统将赏给你30个金币和20的积分"
      send_dz_notify bestanswer.user.dz_common_id, @ask.user.dz_common_id, '', message, 'slove_ask'
      # 给解决问题的人加金币和积分
      add_discuz_extcredits bestanswer.user.dz_common_id, 30
      add_discuz_credits bestanswer.user.dz_common_id, 20
      # 更新这个答案的状态为 checked
      bestanswer.update_attributes({:ifcheck => 1})
      # 发全站动态
      dz_user = session[:login_user]
      ask_index_url = XMAPP_MAIN_DOMAIN_URL+"/asks"
      ask_thread_url = XMAPP_MAIN_DOMAIN_URL+"/asks/#{@ask.id}"
      #title_template = "#{dz_user.username}在<a href=\"#{ask_index_url}\" >问答频道<\/a>提了一个问题<a href=\"#{ask_thread_url}\" >#{@ask.title}<\/a>"
	    answer_user_url = USER_SPACE_URL_BASE.gsub('{dz_uid}', bestanswer.user.dz_common_id.to_s)
	    ask_user_url = USER_SPACE_URL_BASE.gsub('{dz_uid}', @ask.user.dz_common_id.to_s)
	    title_template = "<a href=\"#{answer_user_url}\" >#{@ask.bestanswer_username}<\/a>解决了<a href=\"#{ask_user_url}\" >#{@ask.user.username}<\/a>的问题<a href=\"#{ask_thread_url}\" >#{@ask.title}<\/a>"
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

