class BaomingsController < ApplicationController
  def create
    @baoming = Baoming.new
    @baoming.name = params[:name]
    @baoming.telnum = params[:telnum]
    @baoming.zhuanye = params[:zhuanye]
    @baoming.baokaoxuexiao = params[:baokaoxuexiao]
    @baoming.tuofucj = params[:tuofucj]
    @baoming.campaign = params[:campaign]
    bm_flag = params[:flag]
    if bm_flag.to_s == '1'
      if @baoming.save
        flash[:message] = "报名成功"
        redirect_to :action => "bm_result2"
        #flash.now[:message] = "报名成功"
        #render '/errors_messages.html'
      else
        flash[:error] = "您提交的内容有错误,请重新填写"
        redirect_to :action => "bm_result2"
        #flash.now[:error] = "您提交的内容有错误,请重新填写"
		    #render '/errors_messages.html'
      end
    else
      if @baoming.save
        flash[:message] = "报名成功"
        redirect_to :action => "bm_result"
        #flash.now[:message] = "报名成功"
        #render '/errors_messages.html'
      else
        flash[:error] = "您提交的内容有错误,请重新填写"
        redirect_to :action => "bm_result"
        #flash.now[:error] = "您提交的内容有错误,请重新填写"
		    #render '/errors_messages.html'
      end
    end


  end

  def bm_result

  end
  def bm_result2

  end
end

