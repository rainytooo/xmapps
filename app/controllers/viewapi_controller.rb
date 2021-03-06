class ViewapiController < ApplicationController
  # 所有新问题
  def asks_new
    # 查询最新的问题
    @new_asks = Ask.find_by_sql("SELECT  * FROM asks ORDER by created_at desc limit 9 OFFSET 0 ")
    # 写出文本
    js_text = "document.write('"
    @new_asks.each do |ask|
      js_text += "<li>"
      js_text += "<a title=\"#{ask.title}\" href=\"#{XMAPP_MAIN_DOMAIN_URL}/asks/#{ask.id}\">#{ask.title}"
      js_text += "</a></li>"
    end
    js_text += "');"
    render :text => js_text
  end

  # 所有新解决的问题
  def asks_closed
    # 查询最新解决的问题
    @closed_asks = Ask.find_by_sql("SELECT  * FROM asks where status = 1 or status = 2 ORDER by created_at desc limit 9 OFFSET 0 ")
    # 写出文本
    js_text = "document.write('"
    @closed_asks.each do |ask|
      js_text += "<li>"
      js_text += "<a title=\"#{ask.title}\" href=\"#{XMAPP_MAIN_DOMAIN_URL}/asks/#{ask.id}\">#{ask.title}"
      js_text += "</a></li>"
    end
    js_text += "');"
    render :text => js_text
  end

  # 所有出国留学的 13个
  def asks_chuguo
    ## 所有出国留学的13个
    @closed_asks = Ask.find_by_sql("SELECT  * FROM asks where status = 1 or status = 2 and ask_type_id = 6 ORDER by created_at desc limit 13 OFFSET 0 ")
    # 写出文本
    js_text = "document.write('"
    @closed_asks.each do |ask|
      js_text += "<li>"
      js_text += "<a title=\"#{ask.title}\" href=\"#{XMAPP_MAIN_DOMAIN_URL}/asks/#{ask.id}\">#{ask.title}"
      js_text += "</a></li>"
    end
    js_text += "');"
    render :text => js_text
  end


end

