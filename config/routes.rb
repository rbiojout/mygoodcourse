# == Route Map
#
#                       Prefix Verb      URI Pattern                                              Controller#Action
#                    like_like POST      /likes/like(.:format)                                    likes#like
#                  unlike_like DELETE    /likes/unlike(.:format)                                  likes#unlike
#                  rails_admin           /admin                                                   RailsAdmin::Engine
#                                        /*path(.:format)                                         errors#not_found
#                      reviews GET       /reviews(.:format)                                       reviews#index
#                              POST      /reviews(.:format)                                       reviews#create
#                   new_review GET       /reviews/new(.:format)                                   reviews#new
#                  edit_review GET       /reviews/:id/edit(.:format)                              reviews#edit
#                       review GET       /reviews/:id(.:format)                                   reviews#show
#                              PATCH     /reviews/:id(.:format)                                   reviews#update
#                              PUT       /reviews/:id(.:format)                                   reviews#update
#                              DELETE    /reviews/:id(.:format)                                   reviews#destroy
#                       abuses POST      /abuses(.:format)                                        abuses#create
#                    new_abuse GET       /abuses/new(.:format)                                    abuses#new
#               refund_payment POST      /payments/:id/refund(.:format)                           payments#refund
#                      payment GET       /payments/:id(.:format)                                  payments#show
#                    countries GET       /countries(.:format)                                     countries#index
#                      country GET       /countries/:id(.:format)                                 countries#show
#                  order_items GET       /order_items(.:format)                                   order_items#index
#                              POST      /order_items(.:format)                                   order_items#create
#               new_order_item GET       /order_items/new(.:format)                               order_items#new
#              edit_order_item GET       /order_items/:id/edit(.:format)                          order_items#edit
#                   order_item GET       /order_items/:id(.:format)                               order_items#show
#                              PATCH     /order_items/:id(.:format)                               order_items#update
#                              PUT       /order_items/:id(.:format)                               order_items#update
#                              DELETE    /order_items/:id(.:format)                               order_items#destroy
#              undo_order_item POST      /undo(.:format)                                          order_items#undo
#              myorders_orders GET       /orders/myorders(.:format)                               orders#myorders
#                       orders POST      /orders(.:format)                                        orders#create
#                    new_order GET       /orders/new(.:format)                                    orders#new
#                        order GET       /orders/:id(.:format)                                    orders#show
#                     checkout GET|PATCH /checkout(.:format)                                      orders#checkout
#        checkout_confirmation GET|PATCH /checkout/confirm(.:format)                              orders#confirmation
#                  sort_levels POST      /levels/sort(.:format)                                   levels#sort
#                       levels GET       /levels(.:format)                                        levels#index
#                        level GET       /levels/:id(.:format)                                    levels#show
#                  sort_cycles POST      /cycles/sort(.:format)                                   cycles#sort
#                       cycles GET       /cycles(.:format)                                        cycles#index
#                        cycle GET       /cycles/:id(.:format)                                    cycles#show
#              sort_categories POST      /categories/sort(.:format)                               categories#sort
#                   categories GET       /categories(.:format)                                    categories#index
#                     category GET       /categories/:id(.:format)                                categories#show
#                sort_families POST      /families/sort(.:format)                                 families#sort
#                     families GET       /families(.:format)                                      families#index
#                       family GET       /families/:id(.:format)                                  families#show
#          download_attachment GET       /attachments/:id/download(.:format)                      attachments#download
#             sort_attachments GET       /attachments/sort(.:format)                              attachments#sort
#                              GET       /attachments/:id/download(.:format)                      attachments#download
#                              POST      /attachments/sort(.:format)                              attachments#sort
#                   attachment DELETE    /attachments/:id(.:format)                               attachments#destroy
#         new_employee_session GET       /employees/sign_in(.:format)                             devise/sessions#new
#             employee_session POST      /employees/sign_in(.:format)                             devise/sessions#create
#     destroy_employee_session DELETE    /employees/sign_out(.:format)                            devise/sessions#destroy
#            employee_password POST      /employees/password(.:format)                            devise/passwords#create
#        new_employee_password GET       /employees/password/new(.:format)                        devise/passwords#new
#       edit_employee_password GET       /employees/password/edit(.:format)                       devise/passwords#edit
#                              PATCH     /employees/password(.:format)                            devise/passwords#update
#                              PUT       /employees/password(.:format)                            devise/passwords#update
#                    employees GET       /employees(.:format)                                     employees#index
#                              POST      /employees(.:format)                                     employees#create
#                 new_employee GET       /employees/new(.:format)                                 employees#new
#                edit_employee GET       /employees/:id/edit(.:format)                            employees#edit
#                     employee GET       /employees/:id(.:format)                                 employees#show
#                              PATCH     /employees/:id(.:format)                                 employees#update
#                              PUT       /employees/:id(.:format)                                 employees#update
#                              DELETE    /employees/:id(.:format)                                 employees#destroy
#         new_customer_session GET       /customers/sign_in(.:format)                             customers/sessions#new
#             customer_session POST      /customers/sign_in(.:format)                             customers/sessions#create
#     destroy_customer_session DELETE    /customers/sign_out(.:format)                            customers/sessions#destroy
#            customer_password POST      /customers/password(.:format)                            customers/passwords#create
#        new_customer_password GET       /customers/password/new(.:format)                        customers/passwords#new
#       edit_customer_password GET       /customers/password/edit(.:format)                       customers/passwords#edit
#                              PATCH     /customers/password(.:format)                            customers/passwords#update
#                              PUT       /customers/password(.:format)                            customers/passwords#update
# cancel_customer_registration GET       /customers/cancel(.:format)                              customers/registrations#cancel
#        customer_registration POST      /customers(.:format)                                     customers/registrations#create
#    new_customer_registration GET       /customers/sign_up(.:format)                             customers/registrations#new
#   edit_customer_registration GET       /customers/edit(.:format)                                customers/registrations#edit
#                              PATCH     /customers(.:format)                                     customers/registrations#update
#                              PUT       /customers(.:format)                                     customers/registrations#update
#                              DELETE    /customers(.:format)                                     customers/registrations#destroy
#                  follow_peer POST      /peers/follow(.:format)                                  peers#follow
#                unfollow_peer DELETE    /peers/unfollow(.:format)                                peers#unfollow
#                  buy_product POST      /products/:product_id/buy(.:format)                      products#add_to_basket
#           remove_basket_item DELETE    /products/:order_item_id/remove_from_basket(.:format)    products#remove_from_basket
#                 wish_product POST      /wish_lists/wish(.:format)                               wish_lists#wish
#               unwish_product DELETE    /wish_lists/unwish(.:format)                             wish_lists#unwish
#                 order_status GET       /order/:token(.:format)                                  orders#status
#        accepted_orders_chart GET       /charts/accepted_orders(.:format)                        charts#accepted_orders
#       created_products_chart GET       /charts/created_products(.:format)                       charts#created_products
#       visited_products_chart GET       /charts/visited_products(.:format)                       charts#visited_products
#      created_customers_chart GET       /charts/created_customers(.:format)                      charts#created_customers
#      sign_in_customers_chart GET       /charts/sign_in_customers(.:format)                      charts#sign_in_customers
#        created_reviews_chart GET       /charts/created_reviews(.:format)                        charts#created_reviews
#                         home GET       /:locale/static_pages/home(.:format)                     static_pages#home
#                         help GET       /:locale/help(.:format)                                  static_pages#help
#                      contact GET       /:locale/contact(.:format)                               static_pages#contact
#                        about GET       /:locale/about(.:format)                                 static_pages#about
#                     cheating GET       /:locale/cheating(.:format)                              static_pages#cheating
#         terms_and_conditions GET       /:locale/terms_and_conditions(.:format)                  static_pages#terms_and_conditions
#          myproducts_products GET       /:locale/products/myproducts(.:format)                   products#myproducts
#             catalog_products GET       /:locale/products/catalog(.:format)                      products#catalog
#                     products GET       /:locale/products(.:format)                              products#index
#                              POST      /:locale/products(.:format)                              products#create
#                  new_product GET       /:locale/products/new(.:format)                          products#new
#                 edit_product GET       /:locale/products/:id/edit(.:format)                     products#edit
#                      product GET       /:locale/products/:id(.:format)                          products#show
#                              PATCH     /:locale/products/:id(.:format)                          products#update
#                              PUT       /:locale/products/:id(.:format)                          products#update
#                              DELETE    /:locale/products/:id(.:format)                          products#destroy
#      customer_attach_picture POST      /:locale/customers/:customer_id/attach_picture(.:format) customers#attach_picture
#              circle_customer GET       /:locale/customers/:id/circle(.:format)                  customers#circle
#           wish_list_customer GET       /:locale/customers/:id/wishlist(.:format)                customers#wishlist
#        reviews_list_customer GET       /:locale/customers/:id/reviews_list(.:format)            customers#reviews_list
#           dashboard_customer GET       /:locale/customers/:id/dashboard(.:format)               customers#dashboard
#        credit_cards_customer GET       /:locale/customers/:id/credit_cards(.:format)            customers#credit_cards
#            cash_out_customer GET       /:locale/customers/:id/cash_out(.:format)                customers#cash_out
#                    customers GET       /:locale/customers(.:format)                             customers#index
#                edit_customer GET       /:locale/customers/:id/edit(.:format)                    customers#edit
#                     customer GET       /:locale/customers/:id(.:format)                         customers#show
#                              PATCH     /:locale/customers/:id(.:format)                         customers#update
#                              PUT       /:locale/customers/:id(.:format)                         customers#update
#                              DELETE    /:locale/customers/:id(.:format)                         customers#destroy
#                  sort_topics POST      /:locale/topics/sort(.:format)                           topics#sort
#               topic_articles GET       /:locale/topics/:topic_id/articles(.:format)             articles#index
#                              POST      /:locale/topics/:topic_id/articles(.:format)             articles#create
#            new_topic_article GET       /:locale/topics/:topic_id/articles/new(.:format)         articles#new
#           edit_topic_article GET       /:locale/topics/:topic_id/articles/:id/edit(.:format)    articles#edit
#                topic_article GET       /:locale/topics/:topic_id/articles/:id(.:format)         articles#show
#                              PATCH     /:locale/topics/:topic_id/articles/:id(.:format)         articles#update
#                              PUT       /:locale/topics/:topic_id/articles/:id(.:format)         articles#update
#                              DELETE    /:locale/topics/:topic_id/articles/:id(.:format)         articles#destroy
#                       topics GET       /:locale/topics(.:format)                                topics#index
#                              POST      /:locale/topics(.:format)                                topics#create
#                    new_topic GET       /:locale/topics/new(.:format)                            topics#new
#                   edit_topic GET       /:locale/topics/:id/edit(.:format)                       topics#edit
#                        topic GET       /:locale/topics/:id(.:format)                            topics#show
#                              PATCH     /:locale/topics/:id(.:format)                            topics#update
#                              PUT       /:locale/topics/:id(.:format)                            topics#update
#                              DELETE    /:locale/topics/:id(.:format)                            topics#destroy
#                sort_articles POST      /:locale/articles/sort(.:format)                         articles#sort
#                 stripe_oauth GET       /connect/oauth(.:format)                                 stripe_accounts#oauth
#               stripe_confirm GET       /connect/confirm(.:format)                               stripe_accounts#confirm
#           stripe_deauthorize GET       /connect/deauthorize(.:format)                           stripe_accounts#deauthorize
#               stripe_managed POST      /connect/managed(.:format)                               stripe_accounts#managed
#            stripe_standalone POST      /connect/standalone(.:format)                            stripe_accounts#standalone
#                 hooks_stripe POST      /hooks/stripe(.:format)                                  stripe_hooks#stripe
#                         root GET       /                                                        products#catalog
#                              GET       /:locale(.:format)                                       products#catalog
#
# Routes for RailsAdmin::Engine:
#      stats_users GET         /stats_users(.:format)                      rails_admin/main#stats_users
#        dashboard GET         /                                           rails_admin/main#dashboard
#            index GET|POST    /:model_name(.:format)                      rails_admin/main#index
#              new GET|POST    /:model_name/new(.:format)                  rails_admin/main#new
#           export GET|POST    /:model_name/export(.:format)               rails_admin/main#export
#      bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)          rails_admin/main#bulk_delete
#      bulk_action POST        /:model_name/bulk_action(.:format)          rails_admin/main#bulk_action
#             show GET         /:model_name/:id(.:format)                  rails_admin/main#show
#             edit GET|PUT     /:model_name/:id/edit(.:format)             rails_admin/main#edit
#           delete GET|DELETE  /:model_name/:id/delete(.:format)           rails_admin/main#delete
# sort_for_country GET|POST    /:model_name/:id/sort_for_country(.:format) rails_admin/main#sort_for_country
#   sort_for_topic GET|POST    /:model_name/:id/sort_for_topic(.:format)   rails_admin/main#sort_for_topic
#   sort_for_cycle GET|POST    /:model_name/:id/sort_for_cycle(.:format)   rails_admin/main#sort_for_cycle
#  sort_for_family GET|POST    /:model_name/:id/sort_for_family(.:format)  rails_admin/main#sort_for_family
#    receive_abuse GET         /:model_name/:id/receive_abuse(.:format)    rails_admin/main#receive_abuse
#     accept_abuse GET         /:model_name/:id/accept_abuse(.:format)     rails_admin/main#accept_abuse
#     reject_abuse GET         /:model_name/:id/reject_abuse(.:format)     rails_admin/main#reject_abuse
#     cancel_abuse GET         /:model_name/:id/cancel_abuse(.:format)     rails_admin/main#cancel_abuse
#      show_in_app GET         /:model_name/:id/show_in_app(.:format)      rails_admin/main#show_in_app
#

Rails.application.routes.draw do
  resources :forum_answers
  resources :forum_subjects
  resources :forum_categories, only: [:index, :show] do
    collection do
      post :sort
    end
  end
  resources :forum_families, only: [:index, :show] do
    collection do
      post :sort
    end
  end
  resources :comments
  resources :updates
  # resources :likes
  # Like and unlike other ressources (polymorphic)
  #
  #
  post 'likes/like' => 'likes#like', :as => 'like_like'
  delete 'likes/unlike' => 'likes#unlike', :as => 'unlike_like'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # protect from having all ressources exposed via CDN Cloudfront
  # Deny everything but /assets
  match '*path', via: :all, to: 'errors#not_found',
                 constraints: CloudfrontConstraint.new

  resources :reviews
  # abuses reported for Reviews and Products
  resources :abuses, only: [:new, :create]
  # , only: [:new, :create]
  resources :payments, only: [:show] do
    member do
      post 'refund'
    end
  end
  resources :countries, only: [:index, :show]
  resources :order_items, except: [:show, :new, :edit ] do
    member do
    end
  end
  post 'order_items/undo' => 'order_items#undo', :as => 'undo_order_item'

  resources :orders, only: [:show] do
    collection do
      get 'myorders'
    end
  end

  #
  # Checkout
  #
  match 'checkout' => 'orders#checkout', :as => 'checkout', :via => [:get, :patch]
  match 'checkout/confirm' => 'orders#confirmation', :as => 'checkout_confirmation', :via => [:get, :patch]

  resources :levels, only: [:index, :show] do
    collection do
      post :sort
    end
  end
  resources :cycles, only: [:index, :show] do
    collection do
      post :sort
    end
  end
  resources :categories, only: [:index, :show] do
    collection do
      post :sort
    end
  end

  resources :families, only: [:index, :show] do
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
    unlocks: 'customers/unlocks',
  }
  # devise_scope :customers do
  #  post "/sign_up", :to => "customers/registrations#create"
  #  post "/sign_in", :to => "customers/sessions#create"
  # end

  # Follow and unfollow other peer customers
  #
  #
  post 'peers/follow' => 'peers#follow', :as => 'follow_peer'
  delete 'peers/unfollow' => 'peers#unfollow', :as => 'unfollow_peer'

  #
  # Product browsing
  #
  # get 'products' => 'products#categories', :as => 'catalogue'
  # get 'products/filter' => 'products#filter', :as => 'product_filter'
  # get 'products/:category_id' => 'products#index', :as => 'products'
  # get 'products/:category_id/:product_id' => 'products#show', :as => 'product'

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
  # get 'basket/:id' => 'orders#basket', :as => 'basket'
  # delete 'basket' => 'orders#destroy', :as => 'empty_basket'
  # post 'basket/:order_item_id' => 'orders#change_item_quantity', :as => 'adjust_basket_item_quantity'
  # delete 'basket/:order_item_id' => 'orders#change_item_quantity'
  # delete 'basket/delete/:order_item_id' => 'orders#remove_item', :as => 'remove_basket_item'

  # charts
  #
  # for customers
  get 'charts/accepted_orders' => 'charts#accepted_orders', :as => 'accepted_orders_chart'
  get 'charts/created_products' => 'charts#created_products', :as => 'created_products_chart'
  get 'charts/visited_products' => 'charts#visited_products', :as => 'visited_products_chart'
  # for employees
  get 'charts/created_customers' => 'charts#created_customers', :as => 'created_customers_chart'
  get 'charts/sign_in_customers' => 'charts#sign_in_customers', :as => 'sign_in_customers_chart'
  get 'charts/created_reviews' => 'charts#created_reviews', :as => 'created_reviews_chart'
  get 'charts/catalog_products' => 'charts#catalog_products', :as => 'catalog_products_chart'
  get 'charts/catalog_visits' => 'charts#catalog_visits', :as => 'catalog_visits_chart'

  #
  # position the locale in the URL in order to have a nicer URL
  #
  #
  scope '/:locale', :locale => /fr|en/, :defaults => {:locale => 'fr'} do
    # static pages
    get 'static_pages/home', as: 'home'
    get 'how_it_works' => 'static_pages#how_it_works', as: 'how_it_works'
    get 'help' => 'static_pages#help', as: 'help'
    get 'contact' => 'static_pages#contact', as: 'contact'
    get 'about' => 'static_pages#about', as: 'about'
    get 'cheating' => 'static_pages#cheating', as: 'cheating'
    get 'components' => 'static_pages#components', as: 'components'
    get 'terms_and_conditions' => 'static_pages#terms_and_conditions', as: 'terms_and_conditions'

    # ressources
    resources :products do
      member do
        # get 'detail'
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
        # reviews received by customer
        get :reviews_list, as: 'reviews_list'
        # from the dashbord page add some links
        get :dashboard, :credit_cards, :cash_out
      end
    end

    resources :posts

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
  root to: 'static_pages#home'
  get '/:locale' => 'static_pages#home'

  # root to: 'products#catalog'
  # get '/:locale' => 'products#catalog'

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
  #     resources :reviews, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :reviews
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
