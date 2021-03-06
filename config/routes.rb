Gitagger::Application.routes.draw do
  match 'github/:repo_owner/:repo_name/branches', :to => 'github#branch'
	match 'github/:repo_owner/:repo_name/:branch_name/commits', :constraints => {:branch_name => /[^\/]+/}, :to => 'github#commit'
	match 'github/:repo_owner/:repo_name/commits', :to => 'github#commit'
	match 'github/:repo_owner/:repo_name/tags', :to => 'github#tag'
  match 'github/:repo_owner/:repo_name/:commit_sha/tag', :to => 'github#tagging_page'
  match 'github/:repo_owner/:repo_name/branch/:branch_name/tag', :constraints => {:branch_name => /[^\/]+/}, :to => 'github#tagging_page'
  match 'github/repos', :to => 'github#repo'
  match '/github/tag', :to => 'github#create_tag', :via => :post
  match '/github/tag/delete', :to => 'github#delete_tags', :via => :post
  match '/github/:repo_owner/:repo_name/:commit_sha', :to => 'github#commit_detail'
  match '/github/:repo_owner/:repo_name/:tag/:commit_sha', :constraints => {:tag => /[^\/]+/}, :to => 'github#tag_detail'

  get 'github/tag'

  get 'home/index'

	resources :github do
			get :branch
	end

  #get "sessions/new"

  #get "sessions/create"

  #get "sessions/failure"
  
  #get   '/login', :to => 'sessions#new', :as => :login
  match '/auth/:provider/callback', :to => 'sessions#create'
	get '/login', :to => 'session#create'
	get '/logout', :to => 'sessions#destroy'
	root :to => 'home#index'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
