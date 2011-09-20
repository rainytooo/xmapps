class MailoutController < ApplicationController
  def show
    @mailstr = params[:id]

  end
end

