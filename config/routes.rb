Xmapps::Application.routes.draw do
  # �ʴ�
  #resources :asks do
    # �ҵ��ʴ�
  #  collection do
  #    get 'my'
  #  end
  #  resource :ask_answers
  #end

  # download application
  # ��ҳ
  match "dl" => "downloads/dl_threads#index", :via => [:get], :as => "dl_index"
  # ���ÿ����Դ
  match "dl/:id", :to => "downloads/dl_threads#show", :via => [:get], :as => "dl"
  #�����ϴ����
  match "dl/threads/new", :to => "downloads/dl_threads#simplenew", :via => [:get]
  match "dl/threads", :to => "downloads/dl_threads#simplecreate", :via => [:post]
  # ���������Դ
  match "dl/category/:id", :to => "downloads/dl_threads#category", :via => [:get], :as => "dl_category"
  match "dl/attachment/:id", :to => "downloads/attachments#show", :via => [:get], :as => "dl_attachment"
  match "search", :to => "search#search", :via => [:get]
  # ��ǩ
  resources :tags
  # ǰ̨��ʾ�ͺ�̨�Ĺ���
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
  root :to => "home#index"
  match "index" => "home#index"
  #match "robots" => "home#robots"

  match "login" => "logins#index", :via => [:get]
  match 'login' => 'logins#create', :via => [:post]
  match "logout" => "logins#logout", :via => [:get]

  # �û���Ӧ�ù���
  namespace "manage" do
	resources :uploads
  end

  # uc api
  match "api/uc.php" => "admin#ucapi", :via => [:get]

  get "dztest/index"
  resources :campaigns do
    resources :applies
  end

end

