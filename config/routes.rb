Rails.application.routes.draw do
  # ✅ FIREFOX → ONLY HOME PAGE
  constraints BrowserConstraint.new(allow_firefox: true) do
    root "store#index"
  end

  # ✅ NON-FIREFOX → FULL APP
  constraints BrowserConstraint.new(allow_firefox: false) do
    root "store#index", as: "store_index"

    get "admin" => "admin#index"

    controller :sessions do
      get    "login"  => :new
      post   "login"  => :create
      delete "logout" => :destroy
    end

    namespace :admin do
      get "reports", to: "reports#index"
      post "reports", to: "reports#index"
      get "categories", to: "categories#index"
      get "categories/:id/books", to: "categories#products",
          as: :category_products,
          constraints: { id: /\d+/ }
    end

    resources :categories
    resources :users

    get "my-orders", to: "users#orders"
    get "my-line_items", to: "users#line_items"

    resources :products, path: "books"

    get "up" => "rails/health#show", as: :rails_health_check

    scope "(:locale)" do
      resources :orders
      resources :line_items do
        member do
          patch :add_line_item
          patch :remove_line_item
        end
      end
      resources :carts
    end
  end
end
