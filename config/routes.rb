Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root controller: 'static_pages', action: 'index'
  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    get '/', controller: 'home', action: 'index', as: :home
    
    resources :users do
      post 'restore', on: :member
    end

    resources :products do
      post 'restore', on: :member
    end
  end

  namespace :api do
    post 'sessions', controller: 'sessions', action: 'create'
    resources :users
  end

  match '*path', via: :all, to: 'application#render_404'
end
