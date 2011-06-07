class AskAnswersController < ApplicationController
  before_filter :require_login


  # GET /ask_answers/1/edit
  def edit
    @ask_answer = AskAnswer.find(params[:id])
  end

  # POST /ask_answers
  # POST /ask_answers.xml
  def create
    @ask_answer = AskAnswer.new
    ask = Ask.find_by_id params[:ask_id]
    @ask_answer.ask_id = ask.id
    @ask_answer.user_id = session[:login_user_id]
    @ask_answer.username = session[:login_user].username
    @ask_answer.content = params[:answers_content]
    @ask_answer.save
    # 提问的回复加1
    ActiveRecord::Base.connection.update("update asks set replies = replies+1 where id = #{ask.id}")
    flash[:message] = "您的回答已经成功提交"
    # 发通知给提问的人
    answer_user_url = USER_SPACE_URL_BASE.gsub('{dz_uid}', session[:login_user].uid.to_s)
    your_ask_url = XMAPP_MAIN_DOMAIN_URL+"/asks/#{ask.id}"
    message = "您的问题<a href=\"#{your_ask_url}\" >#{ask.title}<\/a>被<a href=\"#{answer_user_url}\" >#{@ask_answer.username}<\/a>回答了,快去看看吧"
    send_dz_notify ask.user.dz_common_id, session[:login_user].uid, '', message, 'be_answer'

    # 发送全局动态
    dz_user = session[:login_user]
    ask_thread_url = XMAPP_MAIN_DOMAIN_URL+"/asks/#{ask.id}"
    ask_user_url = USER_SPACE_URL_BASE.gsub('{dz_uid}', ask.user.dz_common_id.to_s)
    title_template = "#{dz_user.username}回答了<a href=\"#{ask_user_url}\" >#{ask.user.username}<\/a>的问题<a href=\"#{ask_thread_url}\" >#{ask.title}<\/a>"
    title_data = {}
    require 'php_serialization'
    title_data = PhpSerialization.dump(title_data)
    send_dz_feed 2001, dz_user.uid, dz_user.username, title_template, title_data, '', title_data
    redirect_to ask_path(ask)
  end

  # PUT /ask_answers/1
  # PUT /ask_answers/1.xml
  def update

  end

  # DELETE /ask_answers/1
  # DELETE /ask_answers/1.xml
  def destroy
    @ask_answer = AskAnswer.find(params[:id])
    @ask_answer.destroy

    respond_to do |format|
      format.html { redirect_to(ask_answers_url) }
      format.xml  { head :ok }
    end
  end
end

