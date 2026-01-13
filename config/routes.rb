Rails.application.routes.draw do
  get "admin" => "admin#index"

  controller :sessions do
    get    "login"  => :new
    post   "login"  => :create
    delete "logout" => :destroy
  end


  # Session routes (optional)
  get "admin/index"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"


  namespace :admin do
    get "reports", to: "reports#index"
    post "reports", to: "reports#index"
    get "categories", to: "categories#index"
    get "categories/:id/products", to: "categories#products", as: :category_products, constraints: { id: /\d+/ }
    get "categories/:id/products", to: redirect("/")
  end

  resources :categories

  resources :users

  get "my-orders", to: "users#orders"
  get "my-line_items", to: 'users#line_items'



  resources :products, path: 'books'

  get "up" => "rails/health#show", as: :rails_health_check

  # I18n scoped routes
  scope "(:locale)" do
    resources :orders

    resources :line_items do
      member do
        patch :add_line_item
        patch :remove_line_item
      end
    end

    resources :carts

    root "store#index", as: "store_index"
  end
end
