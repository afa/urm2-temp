Urm::Application.routes.draw do

  resources :news, :only => [:index]
  resources :carts, :except => [:show] do
   collection do
    put :save
   end
  end
  resources :orders, :only => [:index, :new, :show, :create] do
   collection do
    get :lines
    get :control
    get :client_lines
    post :export_client_lines
    post :export_list
   end
   member do
    post :save
    post :close
    post :reserve
    post :unreserve
    post :pick
    post :erase
    post :invoice
   end
  end
  resources :quotations, :only => [:index, :show] do
   collection do
    get :lines
    post :export_list
   end
  end
  resources :users do
   collection do
    get :current_account
    get :balance
    get :limits
    get :sales_report
   end
   resources :accounts
  end
  #resources :passwords, :only => [:new, :create, :edit, :update, :index]
  resources :passwords, :only => [:new, :create]
  resource :sessions, :only => [:new, :create] do
   collection do
    delete :destroy
   end
  end
  resources :main, :only => [:index] do
   collection do
    get :mass_dms
    post :manager_request
    post :search
    post :export
    get :dms
    get :analog
    get :info
    get :set
    get :help
   end
  end
  #get "main/index"
  root :to => "main#index"
  #post "main/manager_request"
  match "/manager_request" => "main#manager_request"
  #post "main/search"
  match "/search" => "main#search"
  #post "main/extended"
  #match "/extended" => "main#extended"
  #get "main/dms"
  #get "main/mass_dms"
  #get "main/analog"
  #get "main/info"
  #get "main/set"
  #get "main/help"

  namespace :admin do
   #resources :main, :only => [:index]
   resources :help_article
   resources :news
   get "main/index"
   root :to => "main#index"
   resources :users do
    resources :passwords, :only => [:index] do
     collection do
      get :edit
      put :update
     end
    end
   end
   resources :managers
   resources :sessions, :only => [:new, :create] do
    collection do
     delete :destroy
    end
   end
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
