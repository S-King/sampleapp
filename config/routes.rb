Rails.application.routes.draw do
  root 'static_pages#home'  # This is referred to using 'root_path'

  get 'help' => 'static_pages#help' # These are named routes
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  
  #Unlike :users which uses resources to get the full suite of RESTful routes
  #we only want :sessions using Named Routes. Get and Post for Login, Destroy for Logout
  #HTTP: GET, POST, UPDATE, DELETE
  get 'login' => 'sessions#new' #URL: /login, NAMEDROUTE: login_path, ACTION: new, page for new sessions
  post 'login' => 'sessions#create' #URL: /login, NAMEDROUTE: login_path, Action: create, create new sessions (login)
  delete 'logout' => 'sessions#destroy' #URL: /logout, NAMEDROUTE: logout_path, Action: destroy, delete session (logout)
  
  resources :users # This is a RESTful resource that comes with CRUD, analagous to HTML's: POST, GET, PATCH, DELETE
  
end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

