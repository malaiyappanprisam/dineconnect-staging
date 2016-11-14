Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  resources :users do
    member do
      get :reset_password
      patch :activate
      patch :deactivate
    end
  end
  resources :restaurants do
    resources :photos, only: [:destroy]
    member do
      patch :activate
      patch :deactivate
    end
  end
  resources :restaurant_batches, only: [:new, :create, :show]
  resources :food_types
  resources :facilities
  resources :areas

  get "/confirm_email/:token", to: "email_confirmations#update", as: "confirm_email"

  namespace :api, defaults: { format: :json } do
    resources :users, only: [:show, :update] do
      member do
        get :recommended_restaurants
        get :favorited_restaurants
      end
    end
    resources :restaurants, only: [:show] do
      member do
        get :recommended_users
      end
    end
    resources :recommended_users, only: [:index]
    resources :recommended_restaurants, only: [:index]
    resources :nationalities, only: [:index]
    resources :invites, only: [:index, :create, :destroy] do
      member do
        post :accept
        post :reject
        post :block
        post :hide
      end
    end
    resources :restaurant_favorites, only: [:create, :destroy]
    resources :chatrooms, only: [:index]
    resources :registrations, path: "register", only: [:create]
    resources :sessions, path: "login", only: [:create]

    post "/facebooks/auth", to: "facebooks#auth", as: "facebooks_auth"

    get "/explore/people", to: "explore#people", as: "explore_people"
    get "/explore/nearby", to: "explore#nearby", as: "explore_nearby"
    get "/explore/places", to: "explore#places", as: "explore_places"
    get "/explore/places_options", to: "explore#places_options", as: "explore_places_options"

    post "/check_auth", to: "tokens#check", as: "check_auth"
    get "/profile/me", to: "profile#me", as: "profile_me"
    patch "/profile/detail", to: "profile#detail", as: "profile_detail"
    patch "/profile/avatar", to: "profile#avatar", as: "profile_avatar"
    post "/profile/forgot_password", to: "profile#forgot_password", as: "profile_forgot_password"
    patch "/profile/password", to: "profile#password", as: "profile_password"
    post "/profile/photos", to: "profile/photos#create", as: "profile_photos"
    delete "/profile/photos/:id", to: "profile/photos#destroy", as: "destroy_profile_photos"
    patch "/profile/location", to: "profile#location", as: "profile_location"
    patch "/profile/deactivate", to: "profile#deactivate", as: "profile_deactivate"
  end

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
end
