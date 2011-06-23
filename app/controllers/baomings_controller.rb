class BaomingsController < ApplicationController
  def create
    baoming = Baoming.new
    baoming.name = params[:name]
    baoming.telnum = params[:telnum]
    baoming.zhuanye = params[:zhuanye]
    baoming.baokaoxuexiao = params[:baokaoxuexiao]
    baoming.tuofucj = params[:tuofucj]
    if baoming.save
      flash.now[:message] = "报名成功"
      render '/errors_messages.html'
    else
      flash.now[:error] = "您提交的内容有错误,请重新填写"
		  render '/errors_messages.html'
    end
  end
end

