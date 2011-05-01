require 'discuz_api'

class DztestController < ApplicationController
  include DiscuzApi
  def index
	passwd_uid = decode_cookie(Rails.configuration.dz_auth_key, request.user_agent, cookies, Rails.configuration.dz_cookie_name)
	logger.info passwd_uid[0] + 'and' + passwd_uid[1]
	
	#@teststr = authcode(dz_cookie_value,true, key_code)
	#@dzuser = Dzuser.find(1)
	respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @campaigns }
    end
  end
end
