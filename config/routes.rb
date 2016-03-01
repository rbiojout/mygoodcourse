Rails.application.routes.draw do

  resources :countries
  resources :order_items
  resources :orders
  resources :levels do
    collection { post :sort }
  end
  resources :cycles
  resources :categories do
    collection { post :sort }
  end

  resources :families
  resources :attachments
  resources :products do
    member do
      #get 'detail'
    end

    collection do
      get 'myproducts'
    end
  end
  devise_for :employees
  resources :employees
  devise_for :customers
  resources :customers

  # static pages
  get 'static_pages/home', as: 'home'
  get 'static_pages/help', as: 'help'
  get 'static_pages/contact', as: 'contact'
  get 'static_pages/about', as: 'about'


  # root page
  root to: 'static_pages#home'

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
end
