Rails.application.routes.draw do

  # SERVICES
  # -- Webhooks and receivers for 3rd party services.

  # PayPal IPN receiver
  post 'paypal_ipn/receiver', to: 'paypal_ipn/receiver#receiver'

  # Inbound email receiver
  post '/email/incoming',     to: 'griddler/emails#create'

  # ADMIN
  namespace 'admin' do
    namespace 'help' do
      resources :comments, only: [:index]
      resources :support_requests, path: 'requests', param: :guid do
        get 'transition_workflow', on: :member

        resource :tags, only: [:create, :destroy]
        resources :comments, only: [:create, :edit, :update, :destroy], shallow: true
      end
      resources :tags, only: [:show], param: :tag
    end

    namespace :kwk, path: 'kult-worship-kaps', as: :kwk do
      resources :kwk_sales, as: :sales, path: 'sales', param: :slug do
        resources :kwk_orders, as: :orders, path: 'orders', only: [:index, :show], param: :guid, shallow: true do
          resources :fulfillments, param: :guid, controller: :kwk_fulfillments , only: [:new, :create, :show, :destroy]
          resources :notes, only: [:new, :create, :destroy], controller: :kwk_order_notes
          resources :approvals, only: [:create], param: :guid
          post 'transition_workflow', on: :member
        end
        resources :kwk_products, as: :products, path: 'products', param: :slug do
          resources :kwk_variants, as: :variants, path: 'variants'
        end

        get 'winners', to: 'winners#index', on: :member
      end
    end

    resources :bro_sales, path: 'bro-caps', param: :slug do
      resources :orders, only: [:index, :show], param: :guid, controller: :bro_sale_orders
      resources :products, param: :slug, controller: :bro_products do
        resources :variants, controller: :bro_variants
        resources :images, controller: :bro_product_images
      end
      resources :images, controller: :bro_sale_images

      get 'winners', to: 'bro_sale_winners#index', on: :member
      get 'purchase_labels', to: 'bro_sale_labels#purchase', on: :member
      get 'download_labels', to: 'bro_sale_labels#download', on: :member
    end

    resources :bro_orders, only: [:index, :show], param: :guid, path: 'bro-orders' do
      resources :fulfillments, param: :guid, controller: :bro_fulfillments do
        member do
          get 'invoice'
          post 'transition_workflow'
        end
      end
      resources :approvals, only: [:create], param: :guid, controller: :bro_approvals
      resources :notes, only: [:new, :create, :destroy], controller: :bro_order_notes
      post 'transition_workflow', on: :member
    end

    resources :group_buys, path: 'buys', param: :slug do
      resources :orders, only: [:index, :show], param: :guid, controller: :group_buy_orders
      resources :products, param: :slug do
        resources :variants
        resources :images, controller: :product_images
      end
      resources :images, controller: :group_buy_images
      resources :microposts
    end

    resources :orders, only: [:index, :show], param: :guid do
      resources :fulfillments, param: :guid do
        member do
          get 'invoice'
          get 'print'
          get 'refund'
          post 'transition_workflow'
        end
      end
      resources :notes, only: [:new, :create, :destroy]
      resources :tracking_notes, only: [:new, :create, :destroy]
      post 'transition_workflow', on: :member
    end

    resources :faq_categories, param: :slug do
      resources :faqs, param: :slug
    end

    resources :bro_line_items, only: [:update]

    resources :send_newsletters, param: :slug, only: [:show]
    resources :newsletters, param: :slug

    resources :shipping_addresses, only: [:edit, :update]
    resources :slack_invites
    resources :users, param: :username
    resources :inquiries, param: :guid

    post 'sort', to: 'sort#sort'
  end

  # STORE
  # -- Store pages.

  get '/buys/store' => redirect('/store')

  namespace 'store' do
    get '/', to: 'products#index'
    resources :products, only: [:show], param: :slug
    resources :categories, only: [:show], param: :slug
  end

  # HELP
  # -- FAQS

  namespace 'help' do
    get '/', to: 'portal#index'
    resources :faqs, only: [:index, :show], param: :slug
    resources :faq_categories, only: [:show], path: 'topics', param: :slug
  end

  # USER ACCOUNT
  # -- Order history, support requests and user details.

  namespace 'account' do
    namespace 'help' do
      resources :support_requests, path: 'requests', param: :guid do
        get 'resolve', to: 'resolve_support_requests#resolve'
        resources :comments, only: [:create]
      end
    end

    namespace 'history' do
      resources :orders, only: [:index, :show, :update], param: :guid do
        resources :fulfillments, only: [:show], param: :guid
      end
      resources :bro_orders, only: [:index, :show], param: :guid, path: 'bros' do
        get 'pay', on: :member
      end
      resources :kwk_orders, only: [:index, :show], param: :guid, path: 'kult-worship-kaps' do
        get 'pay', on: :member
      end
    end
    resources :email_confirmations, only: [:show], param: :confirmation_token, path: 'confirm'
    resources :email_unsubscribe, only: [:show], param: :unsubscribe_token, path: 'unsubscribe'

    get   'info', to: 'profiles#edit'
    patch 'info', to: 'profiles#update'
  end

  # GROUP BUYS
  # -- Anything pertaining to group buys.

  # Checkout flow

  namespace 'checkouts' do
    namespace 'buys' do
      # Your cart
      get '/',   to: 'carts#show'

      # Update quantity or remove item from cart
      resources :line_items, only: [:update, :destroy]

      # Payment information and shipping address
      get 'purchase', to: 'purchases#new'

      # Shipping address
      resources :shipping_addresses, only: [:new, :create, :edit, :update] do
        patch 'verify', on: :member
      end

      # Select shipping service
      patch 'shipping_service', to: 'shipping_services#update'

      # Payment options
      namespace 'payments' do
        # Pay by credit card
        resources :cards
        # Update billing address
        resources :billing_addresses
      end

      # Order email and notes
      patch 'notes', to: 'notes#update'

      # Complete purchase
      post 'purchase/complete', to: 'purchases#create', as: :complete_purchase
    end
  end

  # Sale pages
  resources :group_buys, only: [:index, :show], path: 'buys', param: :slug

  # Add to cart
  resources :line_items, only: [:create]


  # KULT WORSHIP KAPS
  # -- Anything pertaining to KWK.
  # Checkout flow
  namespace 'checkouts' do
    namespace :kwk, path: 'kult-worship-kaps', as: :kwk do
      # Cart (your cart)
      get '/',   to: 'carts#show'

      resources :line_items, only: [:destroy]

      put 'update_count', to: 'kap_count#update'
      post 'sort', to: 'sort#sort'

      # Submissions
      get 'submit', to: 'submissions#new'
      post 'submit/complete', to: 'submissions#create', as: :submit_ticket

      # Geekhack username
      patch 'details', to: 'details#update'

      # Shipping address
      resources :shipping_addresses do
        patch 'verify', on: :member
      end
    end
  end

  # Sale pages
  resources :kwk_sales, only: [:index, :show], path: 'kult-worship-kaps', param: :slug

  # Add to cart
  resources :kwk_line_items, only: [:create] do
    member do
      get 'move_up', controller: :kwk_line_item_positions
      get 'move_down', controller: :kwk_line_item_positions
    end
  end


  # BRO CAPS
  # -- Anything pertaining to Bro Caps. Overrides for custom sale pages.
  # INVASION
  get 'bro-caps/nightstalker', to: redirect('/invasion')
  namespace 'invasion' do
    get '/',   to: 'nightstalker#index'
    get 'buy', to: 'nightstalker#show'
  end

  # INVASION PT II
  get 'bro-caps/invasion-pt-ii', to: redirect('/invasion-pt-ii')
  namespace :invasion_pt_ii, path: 'invasion-pt-ii' do
    get '/',   to: 'corrupted#index'
    get 'buy', to: 'corrupted#show'

    resources :products, only: [:show], param: :slug
  end

  # REAPERS N GAMERS
  get 'bro-caps/reapersngamers', to: redirect('/reapersngamers')
  namespace 'reapersngamers' do
    get '/', to: 'reapersngamers#show'
  end

  # 420
  get 'bro-caps/420', to: redirect('/420')
  namespace :fourtwenty, path: '420' do
    get '/', to: 'fourtwenty#show'
  end

  # Checkout flow
  namespace 'checkouts' do
    namespace 'bros' do
      # Cart (your cart)
      get '/',   to: 'carts#show'

      resources :bro_line_items, only: [:destroy]

      put 'update_count', to: 'bro_count#update'
      post 'sort', to: 'sort#sort'

      # Submissions
      get 'submit', to: 'submissions#new'
      post 'submit/complete', to: 'submissions#create', as: :submit_ticket

      # Geekhack username
      patch 'details', to: 'details#update'

      # Shipping address
      resources :shipping_addresses do
        patch 'verify', on: :member
      end
    end
  end

  # Sale pages
  resources :bro_sales, only: [:index, :show], path: 'bro-caps', param: :slug


  # Add to cart
  resources :bro_line_items, only: [:create] do
    member do
      get 'move_up', controller: :bro_line_item_positions
      get 'move_down', controller: :bro_line_item_positions
    end
  end


  # CONTACT
  # -- Inquiries form/contact page.
  get  'contact', to: 'inquiries#new'
  post 'contact', to: 'inquiries#create'


  # SLACK
  # -- Slack invite page and TOS.
  namespace 'slack' do
    get  'join', to: 'invites#new'
    post 'join', to: 'invites#create'
  end


  # NEWSLETTERS
  # -- Show all sent newsletters.
  resources :newsletters, param: :slug, only: [:index, :show]


  # PAGES
  # -- Mostly static pages.
  get 'terms',   to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
  get 'about',   to: 'pages#about'
  get 'krew',    to: 'pages#krew'
  get 'returns-exchanges', to: 'pages#returns'
  get 'shipping', to: 'pages#shipping'

  # Donations
  resources :donations, only: [:index]


  # USER
  # -- Login, signup and password resets.
  # Password reset
  resources :passwords, param: :password_reset_token, only: [:new, :create, :edit, :update]

  # Login
  resources :sessions, only: [:create], path: 'login'
  get 'login',  to: 'sessions#new',     as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Sign up
  resources :registrations, only: [:create, :show], path: 'signup'
  get 'signup', to: 'registrations#new'


  # CONFIGURATION
  # -- Routes that define configurations.
  # Home
  root 'home/home#index'

  # Errors
  %w[404 422 500].each do |code|
    get code, to: "errors#show", code: code
  end

end
