module Permission
  class UserPermission < BasePermission
    def initialize(user)
      # KWK
      allow_action 'checkouts/kwk/kap_count',  [:update]
      allow_action 'checkouts/kwk/line_items', [:destroy]
      allow_action 'checkouts/kwk/carts',      [:show]
      allow_action 'checkouts/kwk/sort',       [:sort]
      allow_action 'checkouts/kwk/details',    [:update]
      allow_action 'checkouts/kwk/shipping_addresses',  [:new, :create, :edit, :update]
      allow_action 'checkouts/kwk/submissions',         [:new, :create]
      allow_action 'account/history/kwk_orders', [:pay] do |order|
        order.user_id == user.id
      end
      
      allow_action :kwk_sales,      [:index, :show]
      allow_action :kwk_line_items, [:create]
      allow_action :kwk_line_item_positions, [:move_up, :move_down]

      # Slack
      allow_action 'slack/invites', [:new, :create]
      
      # Paypal
      allow_action 'account/history/bro_orders', [:pay]
      
      # Invasion
      allow_action 'fourtwenty/fourtwenty', [:show]
      allow_action 'invasion/nightstalker', [:index, :show]
      allow_action 'invasion_pt_ii/corrupted',      [:index]
      allow_action 'invasion_pt_ii/products',       [:show]
      allow_action 'reapersngamers/reapersngamers', [:show]

      # Newsletters
      allow_action :newsletters, [:index, :show]
      
      # Root
      allow_action 'home/home', [:index]
      
      # Stripe
      allow_action 'stripe_hooks/receiver', [:receiver]

      # Account confirmation
      allow_action 'account/email_confirmations', [:show]

      # Unsubscribe from emails
      allow_action 'account/email_unsubscribe', [:show]

      # Update Account
      allow_action 'account/profiles', [:edit, :update]

      # Support Requests
      allow_action 'account/help/comments', [:create]
      allow_action 'account/help/support_requests', [:index, :new, :create]
      allow_action 'account/help/support_requests', [:show] do |order|
        order.user_id == user.id
      end
      allow_action 'account/help/resolve_support_requests', [:resolve] do |order|
        order.user_id == user.id
      end

      # Order history
      allow_action 'account/history/kwk_orders', [:index]
      allow_action 'account/history/kwk_orders', [:show] do |order|
        order.user_id == user.id
      end

      allow_action 'account/history/bro_orders', [:index]
      allow_action 'account/history/bro_orders', [:show] do |order|
        order.user_id == user.id
      end

      allow_action 'account/history/orders', [:index]
      allow_action 'account/history/orders', [:show] do |order|
        order.user_id == user.id
      end
      allow_action 'account/history/fulfillments', [:show] do |fulfillment|
        fulfillment.order.user_id == user.id
      end

      # Checkout

      # Buys
      allow_action 'checkouts/buys/line_items', [:update, :destroy]
      allow_action 'checkouts/buys/carts', [:show]
      allow_action 'checkouts/buys/notes', [:update]
      allow_action 'checkouts/buys/purchases', [:new, :create]
      allow_action 'checkouts/buys/shipping_addresses', [:verify, :new, :create, :edit, :update]
      allow_action 'checkouts/buys/shipping_services', [:reset_rates, :update]
      allow_action 'checkouts/buys/payments/billing_addresses', [:edit, :update]
      allow_action 'checkouts/buys/payments/cards', [:new, :create]

      # Bros
      allow_action 'checkouts/bros/bro_count', [:update]
      allow_action 'checkouts/bros/bro_line_items', [:destroy]
      allow_action 'checkouts/bros/carts', [:show]
      allow_action 'checkouts/bros/sort',  [:sort]
      allow_action 'checkouts/bros/details',  [:update]
      allow_action 'checkouts/bros/shipping_addresses',  [:new, :create, :edit, :update]
      allow_action 'checkouts/bros/submissions',  [:new, :create]

      # Store
      allow_action 'store/products', [:index, :show]
      allow_action 'store/categories', [:show]

      # Add to cart
      allow_action :bro_line_items, [:create, :update, :destroy]
      allow_action :bro_line_item_positions, [:move_up, :move_down]
      allow_action :line_items, [:create, :update, :destroy]
      
      # Bro Caps
      allow_action 'bro_sales/monster_mash', [:index]
      allow_action :bro_sales, [:index, :show, :newsletter]


      # Group buys
      allow_action 'group_buys/sophomore', [:index]
      allow_action :group_buys, [:index, :show, :newsletter]

      # Help
      allow_action 'help/faqs', [:index, :show]
      allow_action 'help/faq_categories', [:show]

      # Donations
      allow_action :donations, [:index, :new, :create]

      # Contact
      allow_action :inquiries, [:new, :create]

      # Pages
      allow_action :pages, [:about, :terms, :privacy, :refunds, :returns]

      # Log in
      allow_action :sessions, [:new, :destroy]

      # Password reset
      allow_action :passwords, [:new, :create, :edit, :update]
    end
  end
end
