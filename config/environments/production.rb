Xmapps::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  #config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  #config.cache_store = :dalli_store, 'localhost:11211'
  #config.cache_store = :dalli_store, 'cache-1.example.com', 'cache-2.example.com',
    #{ :namespace => NAME_OF_RAILS_APP, :expires_in => 1.day, :compress => true }

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.active_record.default_timezone = 'Beijing'
  # #####################################################################################
  # project config
  # #####################################################################################
  SEARCH_HOST = "127.0.0.1"

  MAIN_DOMAIN = "http://www.xiaoma.com"

  COOKIE_DOMAIN_NAME = ".testxmcmx.com"
  # 主域名
  XMAPP_MAIN_DOMAIN_URL = "http://dl1.testxmcmx.com"
  # 下载服务器的url
  DOWNLOAD_SERVER_URL = "http://dl2.testxmcmx.com"
  # 以下部分是项目用到的常量
  DOWNLOAD_THREAD_PHOTO_ROOT_PATH = "/app/www/img.testxmcmx.com/htdocs/xmappimages"
  DOWNLOAD_THREAD_PHOTO_ROOT_URL = "http://img.testxmcmx.com"
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
  FILE_UPLOAD_DIRECTORY = "/app/www/img.testxmcmx.com/htdocs/attachments"
  # 图片服务器根地址
  IMG_SERVER_URL = "http://imgttt.testxmcmx.com"
  # 一次最大上传附件总数
  MAX_ATTACHMENT_FILES = 10
  # uc space 基础路径
  USER_SPACE_URL_BASE = "http://space.xiaoma.com/space-uid-{dz_uid}.html"
  # 头像路径 默认small
  USER_DISCUZ_SMALL_AVATAR_BASE = "http://bbs.xiaoma.com/uc_server/avatar.php?uid={dz_uid}&size=small"
end

