Xmapps::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.serve_static_assets = true
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  # 缓存设置
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  COOKIE_DOMAIN_NAME = "localhost"
  # 主域名
  XMAPP_MAIN_DOMAIN_URL = "http://localhost:3000"
  # 下载服务器的url
  DOWNLOAD_SERVER_URL = "http://localhost:3001"
  # 以下部分是项目用到的常量
  DOWNLOAD_THREAD_PHOTO_ROOT_PATH = "d:/dev/servers/xampp/htdocs/xmappimages"
  DOWNLOAD_THREAD_PHOTO_ROOT_URL = "http://localhost/xmappimages"
  # discuz 的auth key的配置
  DZ_AUTH_KEY = 'f00c28N7uXnFtcbB'
  # discuz的cookie的名字
  DZ_COOKIE_PRE = '2vNK_'
  DZ_COOKIE_PATH = '/'
  DZ_COOKIE_DOMAIN = ''
  DZ_COOKIE_NAME = DZ_COOKIE_PRE + Digest::MD5.hexdigest(DZ_COOKIE_PATH + "|" + DZ_COOKIE_DOMAIN)[0,4] + "_auth"
  # discuz 表前缀
  DZ_TABLE_PRE = "pre_"
  # 加积分
  DZ_CREDITS_ADD_COUNT = 50
  # 加金币
  DZ_EXTCREDITS_ADD_COUNT = 100
  # 扣积分
  DZ_CREDITS_REDUCE_COUNT = -50
  # 扣金币
  DZ_EXTCREDITS_REDUCE_COUNT = -100
  # 文件上传相关
  FILE_UPLOAD_DIRECTORY = "d:/dev/servers/xampp/htdocs/xmappimages"
  # 下载服务器上的文件根路径
  FILE_DOWNLOAD_DIRECTORY = "d:/dev/servers/xampp/htdocs/xmappimages"
  # 图片服务器根地址
  IMG_SERVER_URL = "http://localhost/xmappimages/"
  # 一次最大上传附件总数 
  MAX_ATTACHMENT_FILES = 10
  # uc space 基础路径
  USER_SPACE_URL_BASE = "http://space.xiaoma.com/space-uid-{dz_uid}.html"
  # 头像路径 默认small
  USER_DISCUZ_SMALL_AVATAR_BASE = "http://bbs.xiaoma.com/uc_server/avatar.php?uid={dz_uid}&size=small"
  
end

