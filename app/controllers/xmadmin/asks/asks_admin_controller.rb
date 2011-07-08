class Xmadmin::Asks::AsksAdminController < ApplicationController
  before_filter :require_admin
  # 显示现在所有的专题
  def ask
    @asks = Ask.order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>30)
  end

  def del_ask
    @ask = Ask.find_by_id params[:id]
    answers = AskAnswer.where("ask_id = ? ", @ask.id)
    answers.each do |answer|
      answer.destroy
    end
    @ask.destroy
    redirect_to :action => "ask"
  end

  def answer
    @answers = AskAnswer.order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>30)
  end

  def del_answer
    answer = AskAnswer.find_by_id params[:id]
    answer.destroy
    redirect_to :action => "answer"
  end

end

