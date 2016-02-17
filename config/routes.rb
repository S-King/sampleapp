Rails.application.routes.draw do
  root 'static_pages#home'  # This is referred to using 'root_path'

  get 'help' => 'static_pages#help' # These are named routes
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'addapage' => 'static_pages#howtoadd'
  #Unlike :users which uses resources to get the full suite of RESTful routes
  #we only want :sessions using Named Routes. Get and Post for Login, Destroy for Logout
  #HTTP: GET, POST, UPDATE, DELETE
  get 'login' => 'sessions#new' #URL: /login, NAMEDROUTE: login_path, ACTION: new, page for new sessions
  post 'login' => 'sessions#create' #URL: /login, NAMEDROUTE: login_path, Action: create, create new sessions (login)
  delete 'logout' => 'sessions#destroy' #URL: /logout, NAMEDROUTE: logout_path, Action: destroy, delete session (logout)
  
=begin
Browsers request pages from Rails by making a request for a URL using a specific HTTP method, such as GET, POST, PATCH, PUT and DELETE. 
Each method is a request to perform an operation on the resource. A resource route maps a number of related requests to actions in a single controller.
When your Rails application receives an incoming request for --> DELETE /photos/17 it asks the router to map it to a controller action. 
If the first matching route is --> resources :photos Rails would dispatch that request to the destroy method on the photos controller with { id: '17' } in params.

HTTP  | Path	         |Controller#Action|    Named Route     	|        Used for
GET	  |/photos	       |photos#index	   |photos_path           |display a list of all photos
GET	  |/photos/new	   |photos#new	     |new_photo_path        |return an HTML form for creating a new photo
POST  |/photos	       |photos#create	   |photos_path           |create a new photo
GET	  |/photos/:id	   |photos#show	     |photo_path(photo)     |display a specific photo
GET	  |/photos/:id/edit|photos#edit	     |edit_photo_path(photo)|return an HTML form for editing a photo
PATCH |/photos/:id     |photos#update    |photo_path(photo)     |update a specific photo
DELETE|/photos/:id	   |photos#destroy   |photo_path(photo)     |delete a specific photo
=end 
  resources :users do # This is a RESTful resource that comes with CRUD, analagous to HTML's: POST, GET, PATCH, DELETE
    member do # get method to arrange for the URLs to respond appropriately. Meanwhile, the member method arranges 
              # for the routes to respond to users/ID/following and users/ID/followers URLs containing the user id
      get :followers, :following
# HTTP request |	 URL	Action	   |        Named route
#     GET      |/users/1/following |following	following_user_path(1)
#     GET      |/users/1/followers |followers	followers_user_path(1)
    end
  end
  resources :account_activation, only: [:edit]
  resources :password_resets,    only: [:new, :create, :edit, :update]
  resources :microposts,         only: [:create, :destroy]
  resources :relationships,      only: [:create, :destroy]
  
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

