module Permission
  class GuestPermission < BasePermission
    def initialize(session_id)
      # Root
      allow_action 'home/home', [:index]

      # PayPal IPN
      allow_action 'paypal_ipn/receiver', [:receiver]

      # Incoming emails
      allow_action 'griddler/emails',       [:create]

      # Bro Caps
      allow_action 'fourtwenty/fourtwenty',         [:show]
      allow_action 'invasion/nightstalker',         [:index, :show]
      allow_action 'invasion_pt_ii/corrupted',      [:index]
      allow_action 'invasion_pt_ii/products',       [:show]
      allow_action 'reapersngamers/reapersngamers', [:show]

      allow_action 'checkouts/bros/bro_count',      [:update]
      allow_action 'checkouts/bros/bro_line_items', [:destroy]
      allow_action 'checkouts/bros/carts',          [:show]
      allow_action 'checkouts/bros/sort',           [:sort]
      
      allow_action :bro_sales, [:index, :show]
      allow_action :bro_line_items, [:create]
      allow_action :bro_line_item_positions, [:move_up, :move_down]

      # KWK
      allow_action 'checkouts/kwk/kap_count',  [:update]
      allow_action 'checkouts/kwk/line_items', [:destroy]
      allow_action 'checkouts/kwk/carts',      [:show]
      allow_action 'checkouts/kwk/sort',       [:sort]

      allow_action :kwk_sales,      [:index, :show]
      allow_action :kwk_line_items, [:create]
      allow_action :kwk_line_item_positions, [:move_up, :move_down]

      # Account confirmation
      allow_action 'account/email_confirmations', [:show]
      
      # Buys
      allow_action 'checkouts/buys/line_items', [:update, :destroy]
      allow_action 'checkouts/buys/carts', [:show]

      # Bros

      # Store
      allow_action 'store/products', [:index, :show]
      allow_action 'store/categories', [:show]

      # Add to cart

      # Group buys
      allow_action :group_buys, [:index, :show]
      allow_action :line_items, [:create]

      # Help
      allow_action 'help/portal', [:index]
      allow_action 'help/faqs', [:index, :show]
      allow_action 'help/faq_categories', [:show]

      # Newsletters
      allow_action :newsletters, [:index, :show]
      
      # Slack
      allow_action 'slack/invites', [:new, :create]

      # Donations
      allow_action :donations, [:index, :new, :create]

      # Contact
      allow_action :inquiries, [:new, :create]

      # Pages
      allow_action :pages, [:krew, :about, :terms, :privacy, :returns, :shipping]

      # Sign up
      allow_action :registrations, [:new, :create]

      # Log in
      allow_action :sessions, [:new, :create]

      # Password reset
      allow_action :passwords, [:new, :create, :edit, :update]
    end
  end
end
