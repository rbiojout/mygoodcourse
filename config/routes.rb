Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # protect from having all ressources exposed via CDN Cloudfront
  # Deny everything but /assets
  match '*path', via: :all, to: 'errors#not_found',
        constraints: CloudfrontConstraint.new

  resources :comments
  # abuses reported for Comments and Products
  resources :abuses, only: [:new, :create]
  #, only: [:new, :create]
  resources :payments, only: [:show] do
    member do
      post 'refund'
    end
  end
  resources :countries
  resources :order_items do
    member do
    end
  end
  post 'undo' => 'order_items#undo', :as => 'undo_order_item'

  resources :orders, only: [:show, :new, :create] do
    collection do
      get 'myorders'
    end
  end

  #
  # Checkout
  #
  match 'checkout' => 'orders#checkout', :as => 'checkout', :via => [:get, :patch]
  match 'checkout/confirm' => 'orders#confirmation', :as => 'checkout_confirmation', :via => [:get, :patch]

  resources :levels do
    collection do
      post :sort
    end
  end
  resources :cycles do
    collection do
      post :sort
    end
  end
  resources :categories do
    collection do
      post :sort
    end
  end

  resources :families do
    collection do
      post :sort
    end
  end

  # attachments are handled directly by product
  get 'attachments/:id/download' => 'attachments#download', :as => 'download_attachment'
  get 'attachments/sort' => 'attachments#sort', :as => 'sort_attachments'

  resources :attachments, only: [:destroy] do
    member do
      get 'download'
    end
    collection do
      post :sort
    end
  end

  devise_for :employees
  resources :employees
  devise_for :customers, controllers: {
             sessions: 'customers/sessions',
             registrations: 'customers/registrations',
             confirmations: 'customers/confirmations',
             passwords: 'customers/passwords',
             unlocks: 'customers/unlocks'
                   }
  #devise_scope :customers do
  #  post "/sign_up", :to => "customers/registrations#create"
  #  post "/sign_in", :to => "customers/sessions#create"
  #end

  # Follow and unfollow other peer customers
  #
  #
  post 'peers/follow' => 'peers#follow', :as => 'follow_peer'
  delete 'peers/unfollow' => 'peers#unfollow', :as => 'unfollow_peer'

  #
  # Product browsing
  #
  #get 'products' => 'products#categories', :as => 'catalogue'
  #get 'products/filter' => 'products#filter', :as => 'product_filter'
  #get 'products/:category_id' => 'products#index', :as => 'products'
  #get 'products/:category_id/:product_id' => 'products#show', :as => 'product'

  post 'products/:product_id/buy' => 'products#add_to_basket', :as => 'buy_product'
  delete 'products/:order_item_id/remove_from_basket' => 'products#remove_from_basket', :as => 'remove_basket_item'

  # Wish and unwish products
  #
  #
  post 'wish_lists/wish' => 'wish_lists#wish', :as => 'wish_product'
  delete 'wish_lists/unwish' => 'wish_lists#unwish', :as => 'unwish_product'


  #
  # Order status
  #
  get 'order/:token' => 'orders#status', :as => 'order_status'

  #
  # Basket
  #
  #get 'basket/:id' => 'orders#basket', :as => 'basket'
  #delete 'basket' => 'orders#destroy', :as => 'empty_basket'
  #post 'basket/:order_item_id' => 'orders#change_item_quantity', :as => 'adjust_basket_item_quantity'
  #delete 'basket/:order_item_id' => 'orders#change_item_quantity'
  #delete 'basket/delete/:order_item_id' => 'orders#remove_item', :as => 'remove_basket_item'

  # charts
  #
  #for customers
  get 'charts/accepted_orders' => 'charts#accepted_orders', :as => 'accepted_orders_chart'
  get 'charts/created_products' => 'charts#created_products', :as => 'created_products_chart'
  get 'charts/visited_products' => 'charts#visited_products', :as => 'visited_products_chart'
  # for employees
  get 'charts/created_customers' => 'charts#created_customers', :as => 'created_customers_chart'
  get 'charts/sign_in_customers' => 'charts#sign_in_customers', :as => 'sign_in_customers_chart'
  get 'charts/created_comments' => 'charts#created_comments', :as => 'created_comments_chart'


  #
  # position the locale in the URL in order to have a nicer URL
  #
  #
  scope "/:locale" do

    # static pages
    get 'static_pages/home', as: 'home'
    get 'help' => 'static_pages#help', as: 'help'
    get 'contact' => 'static_pages#contact', as: 'contact'
    get 'about' => 'static_pages#about', as: 'about'
    get 'cheating' => 'static_pages#cheating', as: 'cheating'
    get 'terms_and_conditions' => 'static_pages#terms_and_conditions', as: 'terms_and_conditions'

    # ressources
    resources :products do
      member do
        #get 'detail'
      end

      collection do
        get 'myproducts'
        get 'catalog'
      end
    end

    # account : all administrative informations
    # - notifications : email and newsletters
    # - credit cards : credit cards used (delete only, add done at payment)
    # - cash-out : stripe account
    # - password change and reset
    #
    # profile : all presentation information
    # - details : name, firstname, adresse, birthdate ....
    # - confidentiality : data that as exposed
    # - presentation : photo, message, vidéo
    # - experience : years of teaching, diploma
    # - circle : followers and followeds

    resources :customers, except: [:new, :create] do
      post 'attach_picture'
      member do
        # from the show page add some links for profile
        get :circle
        # prefered products for customer
        get :wishlist, as: 'wish_list'
        # comments received by customer
        get :comments_list, as: 'comments_list'
        # from the dashbord page add some links
        get :dashboard, :credit_cards, :cash_out

      end
    end

    # elements for the FAQ organized in topics with articles
    resources :topics do
      collection do
        post :sort
      end
      resources :articles
    end
    post 'articles/sort' => 'articles#sort', as: 'sort_articles'

  end
  # end of locale #

  # StripeAccount Connect endpoints
  #  - oauth flow
  get '/connect/oauth' => 'stripe_accounts#oauth', as: 'stripe_oauth'
  get '/connect/confirm' => 'stripe_accounts#confirm', as: 'stripe_confirm'
  get '/connect/deauthorize' => 'stripe_accounts#deauthorize', as: 'stripe_deauthorize'
  #  - create accounts
  post '/connect/managed' => 'stripe_accounts#managed', as: 'stripe_managed'
  post '/connect/standalone' => 'stripe_accounts#standalone', as: 'stripe_standalone'

  # StripeAccount webhooks
  post '/hooks/stripe' => 'stripe_hooks#stripe'


  # root page
  #root to: 'static_pages#home'
  #get '/:locale' => 'static_pages#home'

  root to: 'products#catalog'
  get '/:locale' => 'products#catalog'



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
