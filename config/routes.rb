Rails.application.routes.draw do
  slug = { slug: /[^\/]+/ }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # Authentication Paths
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout
  get '/register', to: 'users#new', as: :registration
  post '/register', to: 'users#create'

  # Cart Paths
  get '/cart', to: 'cart#show'
  post '/cart/items/:slug', to: 'cart#increment', as: :cart_item, constraints: slug
  patch '/cart/items/:slug', to: 'cart#decrement', constraints: slug
  delete '/cart', to: 'cart#destroy', as: :empty_cart
  delete '/cart/items/:slug', to: 'cart#remove_item', as: :remove_item, constraints: slug

  resources :items, only: [:index, :show], param: :slug, constraints: slug
  resources :merchants, only: [:index], param: :slug, constraints: slug

  # User Profile Paths
  get '/profile', to: 'users#show', as: :profile
  get '/profile/edit', to: 'users#edit', as: :edit_profile
  patch '/profile/edit', to: 'users#update'
  namespace :profile do
    resources :orders, only: [:index, :show, :destroy, :create]
  end

  namespace :dashboard do
    get '/', to: 'dashboard#index'

    resources :items, param: :slug, constraints: slug
    patch '/items/:slug/enable', to: 'items#enable', as: 'enable_item', constraints: slug
    patch '/items/:slug/disable', to: 'items#disable', as: 'disable_item', constraints: slug
    put '/order_items/:order_item_id/fulfill', to: 'orders#fulfill', as: 'fulfill_order_item'
    resources :orders, only: [:show]
  end

  namespace :admin do
    get '/dashboard', to: 'dashboard#index'

    patch '/merchants/:slug/downgrade', to: 'merchants#downgrade', as: :downgrade_merchant, constraints: slug
    patch '/users/:slug/upgrade', to: 'users#upgrade', as: :upgrade_user, constraints: slug
    resources :users, only: [:index, :show], param: :slug, constraints: slug

    resources :orders, only: [:show]
    patch '/orders/:order_id/ship', to: 'orders#ship', as: 'order_ship'

    patch '/merchants/:slug/enable', to: 'merchants#enable', as: :enable_merchant, constraints: slug
    patch '/merchants/:slug/disable', to: 'merchants#disable', as: :disable_merchant, constraints: slug
    resources :merchants, only: [:show], param: :slug, constraints: slug do
      resources :items, only: [:index, :new], param: :slug, constraints: slug
      resources :orders, only: [:show]
    end
  end
end
