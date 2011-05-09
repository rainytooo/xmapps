Xmapps::Application.routes.draw do
  resources :dl_images
  # download application
  get "download/index"
  
  namespace "downloads" do
	resources :dl_threads, :dl_images
	namespace "admin" do
		resources :dl_types do
			get 'addsub', :on => :member
		end
	end
  end

  # site index page
  get "home/index"
  root :to => "home#index"
  
  get "admin/login"
  
  match "login" => "admin#index", :via => [:get]
  match 'login' => 'admin#login', :via => [:post]
  match "logout" => "admin#logout", :via => [:get]
  
  # uc api
  match "api/uc.php" => "admin#ucapi", :via => [:get]
  
  get "dztest/index"
  resources :campaigns do
    resources :applies
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end