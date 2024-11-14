Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get "profiles/index"
  resources :likes, only: [:create, :destroy]
  resources :comments

  get "likes/create"
  get "likes/destroy"
  get "likes/like_params"

  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    get '/users/password', to: 'devise/passwords#new'
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:show]

  post 'user/:id/follow', to: "users#follow", as: :follow
  post 'user/:id/unfollow', to: "users#unfollow", as: :unfollow
  post 'user/:id/accept', to: "users#accept", as: :accept
  post 'user/:id/decline', to: "users#decline", as: :decline
  post 'user/:id/cancel', to: "users#cancel", as: :cancel

  get "home/about"
  get "posts/myposts"
  
  resources :posts
  resources :songs

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#about"
end