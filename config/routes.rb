Xmapps::Application.routes.draw do
  # 试听的申请
  resources :auditions do
    collection do
      get 'submit_result_s'
      get 'check_applies'
      post 'applies'
    end
  end

  resources :mailout
  resources :counters

  # ÎÊ¾íµ÷²é
  resources :questionnaires

  # ÑéÖ¤ÂëµÄ
  resources :validate_images do
    collection do
      get 'genvi'
    end
  end

  # ·­ÒëµÄÔ­ÎÄ
  match "sources/search", :to => "sources#search", :via => [:get], :as => "sources_search"
  resources :sources do
    collection do
      #ËùÓÐ·¢²¼µÄ
      get 'release'
      #ËùÓÐ·­ÒëµÄ
      get 'trans'
      # ÎÒde
      get 'my'
      # ÎÒ·¢²¼µÄ
      get 'my_release'
      # ÎÒ·­ÒëµÄ
      get 'my_trans'
      # ËùÓÐÎ´·­ÒëµÄ
      get 'untrans'
      # ·­Òë´óÈü
      get 'match'
    end
    resources :translations do
      # Ìá½»ÆÀÂÛ
      post 'comments'
    end
  end
  # ·­Òë´óÈü
  match "translation_match", :to => "home#translation_match", :via => [:get]

  # ÎÊ´ð
  resources :asks do
    # ÎÒµÄÎÊ´ð
    collection do
      get 'my'
      get 'closed'
      get 'unsolved'
    end
    resource :ask_answers
  end

  # Íâ²¿µ÷ÓÃapi
  resources :viewapi do
    collection do
      get 'asks_new'
      get 'asks_closed'
      get 'asks_unsolved'
      get 'asks_chuguo'
    end
  end

  match "asks/tags/:id", :to => "asks#tags", :via => [:get], :as => "asks_tags"
  # ±¨ÃûµÄÌá½»
  match "baomings", :to => "baomings#create", :via => [:post]
  match "bm_success/:id", :to => "baomings#bm_result", :via => [:get], :as => "bm_success_a"
  match "bm_xm_success", :to => "baomings#bm_result2", :via => [:get]
  match "bm_xmjz_success", :to => "applies#bm_result", :via => [:get]

  # download application
  # Ê×Ò³
  match "dl" => "downloads/dl_threads#index", :via => [:get], :as => "dl_index"
  # ä¯ÀÀÃ¿¸ö×ÊÔ´
  match "dl/:id", :to => "downloads/dl_threads#show", :via => [:get], :as => "dl"
  #¿ìËÙÉÏ´«Èë¿Ú
  match "dl/threads/new", :to => "downloads/dl_threads#simplenew", :via => [:get]
  match "dl/threads", :to => "downloads/dl_threads#simplecreate", :via => [:post]
  # ä¯ÀÀ·ÖÀà×ÊÔ´
  match "dl/category/:id", :to => "downloads/dl_threads#category", :via => [:get], :as => "dl_category"
  match "dl/attachment/:id", :to => "downloads/attachments#show", :via => [:get], :as => "dl_attachment"
  match "search", :to => "search#search", :via => [:get]
  match "searchtest", :to => "search#sockettest", :via => [:get]
  # ±êÇ©
  resources :tags
  # Ç°Ì¨ÏÔÊ¾ºÍºóÌ¨µÄ¹ÜÀí
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

  # ¹ÜÀíÔ±µÇÂ¼
  match "adminlogin" => "admin_login#index", :via => [:get]
  match "adminlogin" => "admin_login#create", :via => [:post]
  # ÓÃ»§µÄÓ¦ÓÃ¹ÜÀí
  namespace "manage" do
	  resources :uploads
  end
  # ºóÌ¨¹ÜÀíÍ³Ò»Èë¿Ú
  namespace "xmadmin" do
    match "index" => "admin_index#index", :via => [:get]
    match "zjfw" => "admin_index#zjfw", :via => [:get]
    # Ñ§Ô±±¨ÃûÐÅÏ¢
    match "zjfw/baoming" => "admin_index#zjfw_baoming", :via => [:get]
    match "searches" => "searches#index", :via => [:get]
    match "searches/new" => "searches#new", :via => [:get]
    match "searches" => "searches#create", :via => [:post]
    match "searches/refresh" => "searches#refresh", :via => [:get]
    match "searches/:id" => "searches#update", :via => [:put]
    namespace "sources" do
      match "source" => "sources_admin#source", :via => [:get]
      match "source/:id" => "sources_admin#del_source", :via => [:delete]
      match "translation" => "sources_admin#translation", :via => [:get]
      match "translation/:id" => "sources_admin#del_translation", :via => [:delete]
    end
    # ÎÊ´ð¹ÜÀí
    namespace "asks" do
      match "ask" => "asks_admin#ask", :via => [:get]
      match "ask/:id" => "asks_admin#del_ask", :via => [:delete]
      match "answer" => "asks_admin#answer", :via => [:get]
      match "answer/:id" => "asks_admin#del_answer", :via => [:delete]
    end
  end
  # uc api
  match "api/uc.php" => "admin#ucapi", :via => [:get]

  get "dztest/index"
  resources :campaigns do
    resources :applies
  end

end

