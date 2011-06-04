namespace :xmapp do
  desc "close all asks unclosed and expired"
  task :close_ask => :environment do
    # get the asks unclosed
    current_time_i = Time.now.to_i
    #ActiveRecord::Base.connection.update("update asks set status = 3 where status = 0 and expiredtime <= #{current_time_i}")
    # 分数要平均分配
    unclosed_asks = Ask.where("status = 0 and expiredtime <= :expiredtime" ,{:expiredtime => current_time_i})
    unclosed_asks.each do |ask|
      answers = AskAnswer.where("ask_id = #{ask.id}")
      if not answers.empty?
         # 得到平均分
        avg_score = (20/answers.size).to_i
        puts avg_score
         # 给每个人加分
        answers.each do |answer|
          add_discuz_extcredits answer.user.dz_common_id, avg_score
        end
      end
       # 关闭问题
      ask.update_attributes({:status => 3})
       # 通知提问者,问题已经关闭
      your_ask_url = XMAPP_MAIN_DOMAIN_URL+"/asks/#{ask.id}"
      message = "您的问题<a href=\"#{your_ask_url}\" >#{ask.title}<\/a>已经超过15天自动关闭了,悬赏将平均分给所有回答问题的人"
      send_dz_notify ask.user.dz_common_id, 1, '', message, 'close_ask'
    end
  end

  # 添加discuz动态
  def send_dz_feed(appid, dz_user_id, dz_user_name, title_template, title_data, body_template, body_data)
	  sql = """
	  INSERT INTO #{DZ_TABLE_PRE}home_feed SET appid=#{appid}, icon='sitefeed', uid=#{dz_user_id}, username='#{dz_user_name}',
			  title_template='#{title_template}', title_data='#{title_data}', body_template='#{body_template}', body_data='#{$body_data}',
			  dateline=#{Time.now.to_i}, body_general='', target_ids=''
	  """
	  Dzxdb.connection.insert(sql)
  end
  # 加discuz积分
  def add_discuz_credits(dz_user_id, counts)
    sql = "update #{DZ_TABLE_PRE}common_member_count set extcredits8 = extcredits8 + #{counts} where uid = #{dz_user_id}"
    puts sql
	  Dzxdb.connection.insert(sql)
  end
  # 加金币
  def add_discuz_extcredits(dz_user_id, counts)
    sql = "update #{DZ_TABLE_PRE}common_member_count set extcredits6 = extcredits6 + #{counts} where uid = #{dz_user_id}"
    puts sql
	  Dzxdb.connection.insert("update #{DZ_TABLE_PRE}common_member_count set extcredits6 = extcredits6 + #{counts} where uid = #{dz_user_id}")
  end
  # 发通知
  def send_dz_notify(dz_user_id, authorid, author, message, from_idtype)
	  sql = """
	  insert into #{DZ_TABLE_PRE}home_notification (uid,type,new,authorid,author,note,dateline,from_id,from_idtype,from_num) VALUES
	  (
		  #{dz_user_id}, 'upload_pass', 1, #{authorid}, '#{author}', '#{message}', #{Time.now.to_i}, 0, '#{from_idtype}', 1
	  )
	  """
	  sql2 = """
	  update #{DZ_TABLE_PRE}common_member_status SET notifications=notifications+1 WHERE uid=#{dz_user_id}
	  """
	  sql3 = """
	  update #{DZ_TABLE_PRE}common_member SET newprompt=newprompt+1 WHERE uid=#{dz_user_id}
	  """
	  Dzxdb.connection.insert(sql)
	  Dzxdb.connection.update(sql2)
	  Dzxdb.connection.update(sql3)
  end
end

