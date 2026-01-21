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

  resources :categories

  resources :users



  resources :products

  get "up" => "rails/health#show", as: :rails_health_check

  # I18n scoped routes
  scope "(:locale)" do
    get "user/orders", to: "users#orders", as: :user_orders

    get "user/line_items", to: "users#line_items", as: :user_line_items
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
