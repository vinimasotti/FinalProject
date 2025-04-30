Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get "profiles/index"
 
  resources :comments

  resources :posts do
    resource :like, only: [:create, :destroy]
  end

  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    get '/users/password', to: 'devise/passwords#new'
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:show]do
  # Nested route to show posts of a user
  get 'posts', to: 'users#posts', as: :posts
end

post 'users/:id/follow', to: 'users#follow', as: :follow
post 'users/:id/unfollow', to: 'users#unfollow', as: :unfollow

  get "home/about"
  get "posts/myposts"
  

  resources :songs do
    member do
      get :download
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#about"
end