Xmapps::Application.routes.draw do


  # 翻译的原文
  match "sources/search", :to => "sources#search", :via => [:get], :as => "sources_search"
  resources :sources do
    collection do
      #所有发布的
      get 'release'
      #所有翻译的
      get 'trans'
      # 我de
      get 'my'
      # 我发布的
      get 'my_release'
      # 我翻译的
      get 'my_trans'
      # 所有未翻译的
      get 'untrans'
    end
    resources :translations
  end

  # 问答
  resources :asks do
    # 我的问答
    collection do
      get 'my'
      get 'closed'
      get 'unsolved'
    end
    resource :ask_answers
  end

  # 外部调用api
  resources :viewapi do
    collection do
      get 'asks_new'
      get 'asks_closed'
      get 'asks_unsolved'
    end
  end

  match "asks/tags/:id", :to => "asks#tags", :via => [:get], :as => "asks_tags"
  # 报名的提交
  match "baomings", :to => "baomings#create", :via => [:post]

  # download application
  # 首页
  match "dl" => "downloads/dl_threads#index", :via => [:get], :as => "dl_index"
  # 浏览每个资源
  match "dl/:id", :to => "downloads/dl_threads#show", :via => [:get], :as => "dl"
  #快速上传入口
  match "dl/threads/new", :to => "downloads/dl_threads#simplenew", :via => [:get]
  match "dl/threads", :to => "downloads/dl_threads#simplecreate", :via => [:post]
  # 浏览分类资源
  match "dl/category/:id", :to => "downloads/dl_threads#category", :via => [:get], :as => "dl_category"
  match "dl/attachment/:id", :to => "downloads/attachments#show", :via => [:get], :as => "dl_attachment"
  match "search", :to => "search#search", :via => [:get]
  match "searchtest", :to => "search#sockettest", :via => [:get]
  # 标签
  resources :tags
  # 前台显示和后台的管理
  namespace "downloads" do
	  resources :dl_threads do
		  # collection do
			  # get  'recrop', 'category'
			  # post :on_offer
		  # end
		  get 'recrop', :on => :member
		  get 'category', :on => :member
		  get 'reuploadimg', :on => :member
		  resources :dl_attachments
	  end
	  resources :attachments do
		  get 'download', :on => :member
	  end
	  namespace "admin" do
		  resources :dl_types do
			  get 'addsub', :on => :member
		  end
		  resources :threads
	  end
  end

  # site index page
  get "home/index"
  match "i_want_credits", :to => "home#i_want_credits", :via => [:get]
  root :to => "home#index"
  match "index" => "home#index"
  #match "robots" => "home#robots"

  match "login" => "logins#index", :via => [:get]
  match 'login' => 'logins#create', :via => [:post]
  match "logout" => "logins#logout", :via => [:get]

  # 用户的应用管理
  namespace "manage" do
	  resources :uploads
  end
  # 后台管理统一入口
  namespace "xmadmin" do
    match "searches" => "searches#index", :via => [:get]
    match "searches/new" => "searches#new", :via => [:get]
    match "searches" => "searches#create", :via => [:post]
    match "searches/refresh" => "searches#refresh", :via => [:get]
    match "searches/:id" => "searches#update", :via => [:put]
  end
  # uc api
  match "api/uc.php" => "admin#ucapi", :via => [:get]

  get "dztest/index"
  resources :campaigns do
    resources :applies
  end

end

