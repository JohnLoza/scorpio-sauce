Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root controller: 'static_pages', action: 'index'
  get 'cities', controller: 'static_pages'
  get 'states', controller: 'static_pages'

  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    get '/', controller: 'home', action: 'index', as: :home

    resources :users do
      post 'restore', on: :member
    end

    resources :products do
      post 'restore', on: :member
    end

    resources :warehouses do
      post 'restore', on: :member
    end

    resources :clients, only: [:index, :show]

    resources :stocks, only: :index do
      get 'transactions', on: :collection
    end

    resources :warehouse_shipments, except: [:edit, :update] do
      post 'process_shipment', on: :member
      post 'report', on: :member
      post 'process_report', on: :member
    end

    resources :supply_orders, except: [:edit, :update] do
      post 'supply', on: :member
    end
  end

  namespace :api do
    post 'sessions', controller: 'sessions', action: 'create'
    resources :clients, except: [:new, :edit] do
      get 'locations', on: :collection
    end

    resources :tickets, except: [:new, :edit, :update]
  end

  match '*path', via: :all, to: 'application#render_404'
end
