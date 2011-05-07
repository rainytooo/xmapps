require 'discuz_api'

class DztestController < ApplicationController
  include DiscuzApi
  def index
	passwd_uid = decode_cookie(Rails.configuration.dz_auth_key, request.user_agent, cookies, Rails.configuration.dz_cookie_name)
	logger.info passwd_uid[0] + 'and' + passwd_uid[1]
	
	#@teststr = authcode(dz_cookie_value,true, key_code)
	#@dzuser = Dzuser.find(1)
	# 测试添加discuz的事件
	#feed = Dzhfeed.new(:appid => 0, :icon => 'doing', :uid => 1, :username => 'admin', :title_template => "{actor} 说李鼎荣是个大傻逼", :body_template => '', :dateline => Time.now, :id => 0)
	#feed.save
	sql = "INSERT INTO `pre_home_feed`" \
		"(`image_3`, `uid`, `id`, `dateline`, `title_template`, `idtype`," \
		"`image_1`, `username`, `body_template`, `image_1_link`, `image_3_link`," \
		"`friend`, `title_data`, `appid`, `body_data`, `image_2_link`, `hot`," \
		"`image_4_link`, `image_4`, `hash_template`, `body_general`, `icon`," \
		"`target_ids`, `hash_data`, `image_2`) VALUES (\'\', 1, 0, 1304675043," \
		"\'{actor}说李鼎荣是个大傻逼\', \'\', \'\', \'admin\', \'\', \'\', \'\', 0, \'\', 0, \'\', \'\', 0, \'\', \'\'," \
		"\'\', \'\', \'doing\', \'\', \'\', \'\')"
	Dzxdb.connection.insert(#{sql})
	respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @campaigns }
    end
  end
end
