XiaomaCom::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # Allow pass debug_assets=true as a query parameter to load pages with unpackaged assets
  config.assets.allow_debugging = true
  
  config.active_record.default_timezone = :local
  
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"
  config.cache_store = :dalli_store, 'localhost:11211',    { :namespace => 'xmapps', :expires_in => 1.day, :compress => true }
  
  MAIN_DOMAIN = "http://www.xmappsdev.com"

  COOKIE_DOMAIN_NAME = ".xmappsdev.com"
  # 主域名
  XMAPP_MAIN_DOMAIN_URL = "http://localhost:3000"
  XMAPP_ASK_DOMAIN_URL = "http://localhost:3000/asks"
  XMAPP_DL_DOMAIN_URL = "http://localhost:3000/dl"
  XMAPP_SOURCE_DOMAIN_URL = "http://localhost:3000/sources"
  # 下载服务器的url
  DOWNLOAD_SERVER_URL = "http://localhost:3001"
  # 以下部分是项目用到的常量
  DOWNLOAD_THREAD_PHOTO_ROOT_PATH = "/var/www/html/xmappimages"
  DOWNLOAD_THREAD_PHOTO_ROOT_URL = "http://localhost/xmappimages"
  # discuz 的auth key的配置
  DZ_AUTH_KEY = '43f91bzQbycNrBkJ'
  # discuz的cookie的名字
  DZ_COOKIE_PRE = '690N_'
  DZ_COOKIE_PATH = '/'
  DZ_COOKIE_DOMAIN = '.xmappsdev.com'
  DZ_COOKIE_NAME = DZ_COOKIE_PRE + Digest::MD5.hexdigest(DZ_COOKIE_PATH + "|" + DZ_COOKIE_DOMAIN)[0,4] + "_auth"
  # discuz 表前缀
  DZ_TABLE_PRE = "pre_"
  # 加积分
  DZ_CREDITS_ADD_COUNT = 50
  # 加金币
  DZ_EXTCREDITS_ADD_COUNT = 20
  # 扣积分
  DZ_CREDITS_REDUCE_COUNT = -50
  # 扣金币
  DZ_EXTCREDITS_REDUCE_COUNT = -20
  # 文件上传相关
  FILE_UPLOAD_DIRECTORY = "/var/www/html/xmappimages"
  # 下载服务器上的文件根路径
  FILE_DOWNLOAD_DIRECTORY = "/var/www/html/xmappimages"
  # 图片服务器根地址
  IMG_SERVER_URL = "http://localhost/xmappimages/"
  # 一次最大上传附件总数
  MAX_ATTACHMENT_FILES = 10
  # uc space 基础路径
  USER_SPACE_URL_BASE = "http://space.xiaoma.com/space-uid-{dz_uid}.html"
  # 头像路径 默认small
  USER_DISCUZ_SMALL_AVATAR_BASE = "http://bbs.xiaoma.com/uc_server/avatar.php?uid={dz_uid}&size=small"
end
